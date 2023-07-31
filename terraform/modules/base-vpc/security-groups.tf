###########
# Allow All
###########

resource "aws_security_group" "allow_all" {
  name        = "${var.prefix}-allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.this.id
  tags = merge(local.default-tags, {
    Name = "${var.prefix}-allow_all"
  })
}
resource "aws_security_group_rule" "allow_all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = [aws_vpc.this.ipv6_cidr_block]
  security_group_id = aws_security_group.allow_all.id
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.allow_all.id
}

#####################
# Allow All Intra VPC
#####################

resource "aws_security_group" "allow_all_intra_vpc" {
  name        = "${var.prefix}-allow_all_intra_vpc"
  description = "Allow all intra-vpc inbound traffic"
  vpc_id      = aws_vpc.this.id
  tags = merge(local.default-tags, {
    Name = "${var.prefix}-allow_all_intra_vpc"
  })
}

resource "aws_security_group_rule" "allow_all_intra_vpc_ingress_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [aws_vpc.this.cidr_block]
  ipv6_cidr_blocks  = [aws_vpc.this.ipv6_cidr_block]
  security_group_id = aws_security_group.allow_all_intra_vpc.id
  description       = "${var.name}-${var.environment} vpc"
}

resource "aws_security_group_rule" "allow_all_intra_vpc_ingress_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.allow_all_intra_vpc.id
}

resource "aws_security_group_rule" "allow_all_intra_vpc_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.allow_all_intra_vpc.id
}

#########
# Outputs
#########

output "aws_security_groups" {
  value = {
    allow_all           = aws_security_group.allow_all
    allow_all_intra_vpc = aws_security_group.allow_all_intra_vpc
  }
}