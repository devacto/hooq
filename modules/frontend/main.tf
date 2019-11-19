provider "aws" {
  region = "ap-southeast-1"
  version = "= 2.32"
}

# data sources to get vpc, subnet and security group details.
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

# auto-scaling group for the frontend
module "frontend_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "= 3.4.0"
  name    = "hooq-frontend-${var.environment}-asg"

  # Launch configuration
  lc_name = "hooq-frontend-${var.environment}-launchconfig"

  image_id        = "ami-0dad20bd1b9c8c004" # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type in ap-southeast-1
  instance_type   = "t2.micro"
  security_groups = [data.aws_security_group.default.id]
  load_balancers  = [module.frontend_elb.this_elb_id]

  associate_public_ip_address  = "false"
  recreate_asg_when_lc_changes = "true"

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "hooq-frontend-${var.environment}-asg"
  vpc_zone_identifier       = data.aws_subnet_ids.all.ids
  health_check_type         = "EC2"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  wait_for_capacity_timeout = "3m"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from HOOQ frontend server" > index.html
              nohup busybox httpd -f -p "80" &
              EOF

  tags = [
    {
      key                 = "Project"
      value               = "hooq-frontend-${var.environment}"
      propagate_at_launch = true
    }
  ]
}

# elb for the frontend
module "frontend_elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "frontend-elb-${var.environment}"

  subnets         = data.aws_subnet_ids.all.ids
  security_groups = [data.aws_security_group.default.id]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  tags = {
    App         = "frontend"
    Environment = "${var.environment}"
    Name        = "hooq-frontend-${var.environment}-elb"
  }
}