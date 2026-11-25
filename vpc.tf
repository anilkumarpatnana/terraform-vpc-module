resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  enable_dns_hostnames = true

  tags = merge(var.vpc_tags, local.common_tags)

}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.igw_tags, local.common_tags,
  
  {
   Name = "${local.common_name}-igw"
  }

  )
}

resource "aws_eip" "main" {
  domain = "vpc"

    tags = merge(var.eip_tags, local.common_tags,
  
  {
   Name = "${local.common_name}-eip(for NATGW)"
  }
    )

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


resource "aws_db_subnet_group" "roboshop" {
  name       = local.common_name
  subnet_ids = aws_subnet.db[*].id
  tags = local.common_tags
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.public_route_table_tags,local.common_tags,
   
   {
    Name = "${local.common_name}-public-route-table"
   }

  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.private_route_table_tags,local.common_tags,
   
   {
    Name = "${local.common_name}-private-route-table"
   }

  )
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.db_route_table_tags,local.common_tags,
   
   {
    Name = "${local.common_name}-db-route-table"
   }

  )
}


resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "db" {
  count = length(aws_subnet.db)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}



resource "aws_nat_gateway" "main" {

  allocation_id = aws_eip.main.id
  subnet_id = aws_subnet.public[0].id

  tags = merge(var.natgw_tags, local.common_tags,
  
  {
   Name = "${local.common_name}-natgw"
  }

  )


  depends_on = [ aws_internet_gateway.main ]
  
  
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id

}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "db" {
  route_table_id         = aws_route_table.db.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id

}

resource "aws_vpc_peering_connection" "main" {
  count = var.is_peering_required ? 1 : 0
  peer_vpc_id   = data.aws_vpc.default.id
  vpc_id        = aws_vpc.main.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }


    tags = merge(var.vpc_peering_tags, local.common_tags,
  
  {
   Name = "${local.common_name}-vpc-peering-with-default-vpc"
  }

  )

}

resource "aws_route" "vpc-peering-public-subnet" {
  count = var.is_peering_required ? 1 : 0
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "vpc-peering-private-subnet" {
  count = var.is_peering_required ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "vpc-peering-db-subnet" {
  count = var.is_peering_required ? 1 : 0
  route_table_id         = aws_route_table.db.id
  destination_cidr_block = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}

resource "aws_route" "vpc-peering-public-subnet-default-vpc" {
  count = var.is_peering_required ? 1 : 0
  route_table_id         = data.aws_route_table.default_vpc_main_route_table.id
  destination_cidr_block = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main[count.index].id
}






