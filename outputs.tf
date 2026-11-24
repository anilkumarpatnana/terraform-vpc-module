output "vpc_id" {

    value = aws_vpc.main.id
  
}

output "azs_info" {

    value = local.azs_info
  
}