terraform {
  required_version = "= 0.12.10"
  backend "s3" {
    bucket = "vwib-terraform-state"
    key    = "hooq.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  region = "ap-southeast-1"
  version = "= 2.32"
}

module "api" {
  source      = "./modules/api"
  environment = "${var.environment}"
}

module "frontend" {
  source      = "./modules/frontend"
  environment = "${var.environment}"
}

module "db" {
  source      = "./modules/db"
  environment = "${var.environment}"
}

module "reverseproxy" {
  source       = "./modules/reverseproxy"
  api_dns      = "${module.api.api_elb_dns_name}"
  frontend_dns = "${module.frontend.frontend_elb_dns_name}"
  environment  = "${var.environment}"
}
