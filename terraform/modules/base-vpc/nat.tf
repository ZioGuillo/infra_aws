##############
# NAT Gateways
##############

// Currently default to a single gateway, but when scaling change this
// to be in each region
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnets["nat-a"].id
  depends_on    = [aws_internet_gateway.this]

  tags = merge(local.default-tags, {
    Name = "${var.name}-${var.environment}"
  })
}

output "nat" {
  value = aws_nat_gateway.nat
}

#############
# Elastic IPs
#############

resource "aws_eip" "nat" {

  domain = "vpc"
  tags = merge(local.default-tags, {
    Name = "${var.name}-${var.environment}-nat"
  })
}


########
# Routes
########

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_default_network_acl" "default" {
  #vpc_id = aws_vpc.this.id
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  tags = merge(local.default-tags, {
    Name = "${var.name}-${var.environment}"
  })
}

resource "aws_default_vpc_dhcp_options" "default" {

  tags = merge(local.default-tags, {
    Name = "${var.name}-${var.environment}"
  })
}