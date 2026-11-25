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
  
}


variable "public_subnet_tags" {
      type = map

    default = {}

}






variable "cidr_block_private_subnet" {

    type = list
  
}


variable "private_subnet_tags" {
      type = map

    default = {}

}







variable "cidr_block_db_subnet" {

    type = list
  
}



variable "db_subnet_tags" {
      type = map

    default = {}

}

variable "public_route_table_tags" {
    type = map

    default = {}

  
}

variable "private_route_table_tags" {
    type = map

    default = {}

}

variable "db_route_table_tags" {
    type = map

    default = {}

}

variable "eip_tags" {
    type = map

    default = {}

}

variable "natgw_tags" {
    type = map

    default = {}

}

variable "is_peering_required" {
  default = false
}

variable "vpc_peering_tags" {

    type = map

    default = {}

  
}
     

     