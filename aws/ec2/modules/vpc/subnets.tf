resource "aws_subnet" "public" {
  for_each = var.availability_zones

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 8 + index(tolist(var.availability_zones), each.key))
  map_public_ip_on_launch = true
  availability_zone       = each.key

  tags = merge(var.extra_tags,
    {
      Name = "Public ${each.key}"
    }
  )
}

output "subnets_public" {
  value = [for network in aws_subnet.public : network]
}

resource "aws_subnet" "private" {
  for_each = var.availability_zones

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 12 + index(tolist(var.availability_zones), each.key))
  availability_zone = each.key

  tags = merge(var.extra_tags,
    {
      Name = "Private ${each.key}"
    }
  )
}

output "subnets_private" {
  value = [for network in aws_subnet.private : network]
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.extra_tags,
    {
      Name = "${var.name} IGW"
    }
  )
}

resource "aws_eip" "ngw" {
  for_each = var.availability_zones

  vpc = true

  tags = merge(var.extra_tags,
    {
      Name = "${var.name} NGW ${each.key}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  for_each = var.availability_zones

  allocation_id = aws_eip.ngw[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(var.extra_tags,
    {
      Name = "${var.name} NGW ${each.key}"
    }
  )
}
