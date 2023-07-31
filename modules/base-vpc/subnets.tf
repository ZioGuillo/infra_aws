###################
# Local definitions
###################

// Subnet configurable values
locals {
  subnet-defaults = {
    public = false
  }

  subnet-configs = {
    private = {
      block = "${var.cidr_base}.0.0/17"
    }
    public = {
      block  = "${var.cidr_base}.128.0/18"
      public = true
      tags = {
        "": 1
      }
    }
    fortknox = {
      block = "${var.cidr_base}.192.0/20"
    }
    nat = {
      block                   = "${var.cidr_base}.208.0/23"
      public                  = true
      map_public_ip_on_launch = false
    }
    private-elb = {
      block = "${var.cidr_base}.210.0/23"
      tags = {
        "" = 1
      }
    }
    # vpn = {
    #   block = "${var.cidr_base}.212.0/24"
    # }
  }
}

// Flatten subnet and AZ maps and transform as necessary
locals {
  subnets = flatten([
    for subnet-key, subnet in local.subnet : [
      for az in local.subnet-az : {
        name        = subnet-key
        block       = subnet.block
        public      = try(subnet.public, false)
        count       = az.count
        zone-letter = az.zone-letter
        cidr_block = cidrsubnet(
          subnet.block,
          ceil(log(local.region-count, 2)),
          az.count
        )
        availability_zone       = "${var.aws_region}${az.zone-letter}"
        map_public_ip_on_launch = try(subnet.map_public_ip_on_launch, subnet.public, false)

        tags = merge({
          Name = "${var.name}-${var.environment}-${subnet-key}-${az.zone-letter}"
          },
          can(subnet.tags) ? subnet.tags : {}, // Merges with {} if tags are not defined
          local.default-tags
        )
      }
    ]
  ])
}

// DO NOT EDIT
// Default values and local vars for computational purposes
locals {
  region-count = var.region-az-count-mapping[var.aws_region]

  subnet-az = [for i in range(local.region-count) : {
    count       = i
    zone-letter = var.number-to-letter-mapping[i]
  }]

  subnet = {
    for name, value in local.subnet-configs : name => merge(
      local.subnet-defaults,
      value
    )
  }
}

##########
# Subnets
##########

resource "aws_subnet" "subnets" {
  for_each = {
    for subnet in local.subnets : "${subnet.name}-${subnet.zone-letter}" => subnet
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  #network_acl_id          = aws_network_acl.net_acl.id

  tags = {
    Name = each.value.availability_zone
    Environment = "${var.environment}"
  }
}
