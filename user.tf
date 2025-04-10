data "aws_caller_identity" "current" {}

locals {
  # Extract the username (last part after '/')
  username    = element(split("/", data.aws_caller_identity.current.arn), length(split("/", data.aws_caller_identity.current.arn)) - 1)
  name_prefix = "${local.username}-"
}

# Output the locals
output "extracted_username" {
  value       = local.username
  description = "The extracted IAM username from the caller identity"
}

output "name_prefix" {
  value       = local.name_prefix
  description = "The naming prefix to be used for resources"
}

