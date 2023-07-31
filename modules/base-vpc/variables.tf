variable "name" {
  type = string
  validation {
    condition     = length(var.name) > 0
    error_message = "The 'name' value must not be an empty string."
  }
}

variable "environment" {
  type = string
  validation {
    condition     = length(var.environment) > 0
    error_message = "The 'environment' value must not be an empty string."
  }
}

variable "aws_region" {
  description = "Amazon Web Services region (e.g. \"us-west-2\")"
  type        = string
  validation {
    condition     = length(regexall(".-.", var.aws_region)) > 0
    error_message = "The 'region' value must consist of 2 or more strings joined by hyphens."
  }
}

variable "cidr_base" {
  description = "First 2 numbers of dotted-quad IP address. Example: \"10.205\"."
  type        = string
  validation {
    condition     = length(regexall("^\\d{1,3}\\.\\d{1,3}$", var.cidr_base)) > 0
    error_message = "The 'cidr_base' value must be 2 numbers separated by a dot."
  }
}

variable "prefix" {
  description = "String used as prefix for generating names and tags for AWS security groups. (You may wish to use the name of the Terraform workspace, available as terraform.workspace.)"
  type        = string
  validation {
    condition     = length(var.prefix) > 0
    error_message = "The 'prefix' value must not be an empty string."
  }
  validation {
    condition     = length(regexall("[-_]$", var.prefix)) == 0
    error_message = "The 'prefix' value must not end with a hyphen or underscore."
    /*
      This check is arguably unnecessary, but was included to prevent people
      wondering whether the user of the module is responsible for adding the
      hyphen.
    */
  }
}

variable "region-az-count-mapping" {
  type        = map(string)
  description = "Map AWS region to its number of zones"

  default = {
    eu-central-1 = 3
    eu-west-1    = 3
    eu-west-2    = 3
    us-east-1    = 6
    us-east-2    = 3
    us-west-1    = 3
    us-west-2    = 3
  }
}

variable "number-to-letter-mapping" {
  type        = map(string)
  description = "Map of number to alpha for quick maps when using count"

  default = {
    0 = "a"
    1 = "b"
    2 = "c"
    3 = "d"
    4 = "e"
    5 = "f"
  }
}

variable "default-tags" {
  type        = map(string)
  description = "Map of default tags for AWS resources"

  default = {
    ManagedByTerraform = "True"
  }
}