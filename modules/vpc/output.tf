output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "sub1_id" {
  value = aws_subnet.subnet-1.id
}

output "sub2_id" {
  value = aws_subnet.subnet-2.id
}

output "igw_id" {
    value = aws_internet_gateway.my_igw.id
}

output "nat_id" {
  value = aws_nat_gateway.nat.id
}