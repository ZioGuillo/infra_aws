############ Terragrunt ############
variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "routes_val" {
  type        = number
  description = "Number of API Routes"
}

variable "allowed_dl_admins" {
  type        = list(string)
  default     = [
    "id01",
    "id02",
  ]
  description = "List of ARNs that can assume the role of data lake admin"
}