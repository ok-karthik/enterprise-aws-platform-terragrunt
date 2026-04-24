# 🛡️ Global Validation Layer (schema.hcl-like functionality)
# This file defines shared constraints that all modules must satisfy.

locals {
  # Load basic variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.env

  # Load region variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region  = local.region_vars.locals.aws_region
}

# --- GLOBAL CONSTRAINTS ---

validation {
  condition     = contains(["dev", "prod", "staging"], local.env)
  error_message = "❌ ERROR: Unsupported environment '${local.env}'. Must be dev, prod, or staging."
}

validation {
  condition     = can(regex("^[a-z0-9-]+$", local.env))
  error_message = "❌ ERROR: Environment name '${local.env}' must be alphanumeric and hyphenated."
}

validation {
  condition     = startswith(local.aws_region, "eu-") || startswith(local.aws_region, "us-")
  error_message = "❌ ERROR: Platform only supports EU and US regions for compliance."
}

# --- TAGGING COMPLIANCE ---
# Note: Specific modules can extend this.
validation {
  condition     = length(local.env) > 0
  error_message = "❌ ERROR: Environment tag is mandatory."
}
