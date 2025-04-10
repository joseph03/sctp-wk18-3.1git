# Private Subnets
resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24" # 10.0.10.0/24, 10.0.11.0/24, 10.0.12.0/24
  availability_zone = "us-east-1${["a", "b", "c"][count.index]}"
  tags = {
    Name = "${local.name_prefix}private-subnet-${count.index}"
  }
}

# Private Route Table with NAT
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id # link to NAT
  }

  tags = {
    Name = "${local.name_prefix}private-rt"
  }
}

resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
