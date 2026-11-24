locals {

common_name  = "${var.project}-${var.environment}"

common_tags = {

  project = var.project

  environment  = var.environment

  terraform = "true"
  
  Name  = local.common_name

}

azs_info = slice(data.aws_availability_zones.available.names, 0, 2)

}