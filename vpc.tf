resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  enable_dns_hostnames = true

  tags = merge(var.vpc_tags, local.common_tags)

}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.igw_tags, local.common_tags)
}


resource "aws_subnet" "public" {
  count = length(var.cidr_block_public_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_public_subnet[count.index]
  map_public_ip_on_launch = true
  availability_zone = local.azs_info[count.index]
  tags = merge(var.public_subnet_tags, local.common_tags,
     {
   Name = "${local.common_name}-public-${split("-",local.azs_info[count.index])[2]}"

   }
)
}


resource "aws_subnet" "private" {
  count = length(var.cidr_block_private_subnet)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_private_subnet[count.index]
  availability_zone = local.azs_info[count.index]
  tags = merge(var.private_subnet_tags, local.common_tags,
     {
   Name = "${local.common_name}-private-${split("-",local.azs_info[count.index])[2]}"

   }
)
}


resource "aws_subnet" "db" {
  count = length(var.cidr_block_db_subnet)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_db_subnet[count.index]
  availability_zone = local.azs_info[count.index]
  tags = merge(var.db_subnet_tags, local.common_tags,
   {
   Name = "${local.common_name}-db-${split("-",local.azs_info[count.index])[2]}"

   }
   )
}


