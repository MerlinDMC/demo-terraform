resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.extra_tags,
    {
      Name = "${var.name} RT Public"
    }
  )
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  for_each = var.availability_zones

  vpc_id = aws_vpc.main.id

  tags = merge(var.extra_tags,
    {
      Name = "${var.name} RT Private ${each.key}"
    }
  )
}

resource "aws_route" "private_ngw" {
  for_each = var.availability_zones

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each = var.availability_zones

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = var.availability_zones

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
