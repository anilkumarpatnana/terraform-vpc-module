output "vpc_id" {

    value = aws_vpc.main.id
  
}

output "igw_id" {

    value = aws_internet_gateway.main.id
  
}

output "eip_address" {

    value = aws_eip.main.public_ip
}

output "eip_id" {

    value = aws_eip.main.id
}

output "natgw_id" {

    value = aws_nat_gateway.main.id
  
}

output "public_subnet_ids" {
  
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  
  value = aws_subnet.private[*].id
}

output "db_subnet_ids" {
  
  value = aws_subnet.db[*].id
}


output "public_route_table_id" {
    value = aws_route_table.public.id
}

output "private_route_table_id" {
    value = aws_route_table.private.id
}

output "db_route_table_id" {
    value = aws_route_table.db.id
}