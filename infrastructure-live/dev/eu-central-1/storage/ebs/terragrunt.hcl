# 🧬 Terragrunt configuration for storage/ebs
# This module inherits from the root and envcommon layers.

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path = "${get_repo_root()}/infrastructure-live/_envcommon/storage/ebs.hcl"
}

# Add module-specific inputs here if they differ from _envcommon
inputs = {
  # tags = {
  #   CustomTag = "Value"
  # }
}
