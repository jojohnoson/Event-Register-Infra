resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_internet_gateway" "my_igw"{
    vpc_id = aws_vpc.my_vpc.id

    tags = {
      Name = "my_igw"
    }
}

resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.rt-1_cidrblock
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "rt-1"
  }
}

resource "aws_subnet" "subnet-1"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.sub1_cidr_block
    availability_zone = var.sub1_az
    map_public_ip_on_launch = true

    tags = {
      Name = "Subnet-1"
    }
}

resource "aws_subnet" "subnet-2"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.sub2_cidr_block
    availability_zone = var.sub2_az
    map_public_ip_on_launch = false

    tags = {
      Name = "Subnet-2"
    }
}

resource "aws_route_table_association" "rta-1" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.rt-1.id
}

resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my_igw]

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet-1.id

  tags = {
    Name = "NAT"
  }

  depends_on = [aws_internet_gateway.my_igw]
}


resource "aws_route_table" "rt-2"{
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = var.rt-2_cidrblock
        nat_gateway_id = aws_nat_gateway.nat.id
    }

    tags = {
      Name = "rt-2"
    }
}

resource "aws_route_table_association" "rta-2" {
  subnet_id = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.rt-2.id
}







