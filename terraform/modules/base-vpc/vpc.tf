resource "aws_vpc" "this" {
  cidr_block           = "${var.cidr_base}.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  assign_generated_ipv6_cidr_block = true

   tags = merge(local.default-tags, {
    Name = "${var.name}-${var.environment}"
  })
}
