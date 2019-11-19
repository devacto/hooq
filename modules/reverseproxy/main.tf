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

resource "aws_alb" "alb" {
  name            = "reverse-proxy-alb-${var.environment}"
  subnets         = data.aws_subnet_ids.all.ids
  security_groups = [data.aws_security_group.default.id]
  enable_http2    = "true"
  idle_timeout    = 600
  tags            = {
    Name = "reverse-proxy-alb-${var.environment}"
    Environment = "${var.environment}"
  }
}

# configuring the listeners
resource "aws_alb_listener" "reverse_proxy" {
  load_balancer_arn = "${aws_alb.alb.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "From HOOQ Server: Not found."
      status_code  = "404"
    }
  }
}

# configuring listener rule for the api.
resource "aws_alb_listener_rule" "api_listener_rule" {
  listener_arn = "${aws_alb_listener.reverse_proxy.arn}"
  priority     = "1"
  action {
    type          = "redirect"
    redirect {
      host        = "${var.api_dns}"
      port        = "80"
      protocol    = "HTTP"
      status_code = "HTTP_301"
      path        = "/"
    }
  }
  condition {
    field  = "path-pattern"
    values = ["/api"]
  }
}
