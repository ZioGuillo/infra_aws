####################
# Publiс route table
####################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge(local.default-tags, {
    Name = "${var.name}-${var.environment}-public"
  })
}

output "route_table-public" {
  value = aws_route_table.public
}


# Associations
resource "aws_route_table_association" "public" {
  for_each = {
    for az in local.subnet-az : az.zone-letter => az
  }

  subnet_id      = aws_subnet.subnets["public-${each.value.zone-letter}"].id
  route_table_id = aws_route_table.public.id
}

#################
# NAT route table
#################
resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.default-tags, {
    Name = "${var.name}-${var.environment}-nat"
  })
}

output "aws_route_table-nat" {
  value = aws_route_table.nat
}

# Associations
resource "aws_route_table_association" "public_nat" {
  for_each = {
    for az in local.subnet-az : az.zone-letter => az
  }

  subnet_id      = aws_subnet.subnets["nat-${each.value.zone-letter}"].id
  route_table_id = aws_route_table.nat.id
}

#####################
# Private route table
#####################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.default-tags, {
    Name = "${var.name}-${var.environment}-private"
  })
}

output "private_route_tables" {
  value = aws_route_table.private
}

# Associations
resource "aws_route_table_association" "private" {
  for_each = {
    for az in local.subnet-az : az.zone-letter => az
  }
  subnet_id      = aws_subnet.subnets["private-${each.value.zone-letter}"].id
  route_table_id = aws_route_table.private.id
}

#########################
# Private ELB route table
#########################
resource "aws_route_table" "private_elb" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.default-tags, {
    Name = "${var.name}-${var.environment}-private_elb"
  })
}

output "private_elb_route_tables" {
  value = aws_route_table.private_elb
}

# Associations
resource "aws_route_table_association" "private_elb" {
  for_each = {
    for az in local.subnet-az : az.zone-letter => az
  }
  subnet_id      = aws_subnet.subnets["private-elb-${each.value.zone-letter}"].id
  route_table_id = aws_route_table.private_elb.id
}

########################
# Fort Knox route tables
########################

resource "aws_route_table" "fortknox" {
  vpc_id = aws_vpc.this.id

  tags = merge(local.default-tags, {
    Name = "${var.name}-${var.environment}-fortknox"
  })
}

output "aws_route_table-fortknox" {
  value = aws_route_table.fortknox
}

# Associations
resource "aws_route_table_association" "fortknox" {
  for_each = {
    for az in local.subnet-az : az.zone-letter => az
  }
  subnet_id      = aws_subnet.subnets["fortknox-${each.value.zone-letter}"].id
  route_table_id = aws_route_table.fortknox.id
}
