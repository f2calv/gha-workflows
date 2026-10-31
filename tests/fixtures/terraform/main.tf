# Minimal root module used by this repository's CI to exercise terraform.yml validation.
terraform {
  required_version = ">= 1.13"
}

output "fixture" {
  description = "Constant value proving the module validates."
  value       = "ok"
}
