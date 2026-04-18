include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Point to your local module
  # In real life, this would be a Git URL
  source = "../../../../../../modules/s3"
}

locals {
  # YOU MUST LOAD IT HERE AGAIN to use it in this file
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.env
}

inputs = {
  # This is the only place we define values!
  bucket_name = "tg-learning-bucket-${local.env}-12345" # Must be globally unique

  tags = {
    Project = "App Logs"
  }
}