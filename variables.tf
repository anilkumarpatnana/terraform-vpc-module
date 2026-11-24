variable "project" {
    type = string
  
}

variable "environment" {

    type = string
  
}


variable "vpc_cidr" {

    type = string
    default =  "10.0.0.0/16"
  
}

variable "vpc_tags" {

    type = map

    default = {}
}


variable "igw_tags" {

    type = map

    default = {}
}

variable "cidr_block_public_subnet" {

    type = list
  
    default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "region_public_subnet" {

    type = list
  
    default = ["us-east-1a","us-east-1b"]
}


variable "cidr_block_private_subnet" {

    type = list
  
    default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "region_private_subnet" {

    type = list
  
    default = ["us-east-1a","us-east-1b"]
}



variable "cidr_block_db_subnet" {

    type = list
  
    default = ["10.0.21.0/24","10.0.22.0/24"]
}

variable "region_db_subnet" {

    type = list
  
    default = ["us-east-1a","us-east-1b"]
}


variable "public_subnet_tags" {
      type = map

    default = {}

}


variable "private_subnet_tags" {
      type = map

    default = {}

}

variable "db_subnet_tags" {
      type = map

    default = {}

}

     

     