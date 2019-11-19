provider "aws" {
  region = "ap-southeast-1"
  version = "= 2.32"
}

resource "aws_db_instance" "hooqdb" {
  identifier           = "hooqdb-${var.environment}"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "hooq"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = "true"
  skip_final_snapshot  = "true"
  tags                 = {
    environment = var.environment
  }
}