data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  context    = "arn:aws:eks:${var.region}:${local.account_id}:cluster/${local.cluster_name}"
}

variable "project_id" {
  type = string
}

variable "project_number" {
  type = number
}

variable "admin_users" {
  type = string
}

variable "platform_version" {
  type = string
}

# module "fleet" {
#   source  = "terraform-google-modules/gcloud/google"
#   version = "~> 2.0"

#   platform              = "linux"
#   additional_components = ["kubectl", "beta"]

#   create_cmd_entrypoint = "${path.module}/scripts/register.sh"
#   create_cmd_body       = "${var.region} ${local.cluster_name} ${local.context} ${module.eks.cluster_oidc_issuer_url}"

#   destroy_cmd_entrypoint = "${path.module}/scripts/unregister.sh"
#   destroy_cmd_body       = "${local.cluster_name} ${local.context}"

#   module_depends_on = [module.gateway-rbac]
# }

# module "gateway-rbac" {
#   source  = "terraform-google-modules/gcloud/google"
#   version = "~> 2.0"

#   platform              = "linux"
#   additional_components = ["kubectl", "beta"]

#   create_cmd_entrypoint = "${path.module}/scripts/generate-gateway-rbac.sh"
#   create_cmd_body       = "${var.region} ${local.cluster_name} ${var.admin_users} ${var.project_id} ${local.context} --apply"

#   destroy_cmd_entrypoint = "${path.module}/scripts/generate-gateway-rbac.sh"
#   destroy_cmd_body       = "${var.region} ${local.cluster_name} ${var.admin_users} ${var.project_id} ${local.context} --revoke"

#   module_depends_on = [module.eks]
# }

module "attached" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 2.0"

  platform              = "linux"
  additional_components = ["kubectl", "beta"]

  create_cmd_entrypoint = "${path.module}/scripts/attach.sh"
  create_cmd_body       = "${local.cluster_name} ${var.region} ${var.platform_version} ${var.project_number} ${module.eks.cluster_oidc_issuer_url} ${var.project_id}"

  destroy_cmd_entrypoint = "${path.module}/scripts/unattach.sh"
  destroy_cmd_body       = "${local.cluster_name} ${var.project_id}"

  module_depends_on = [module.eks]
}
