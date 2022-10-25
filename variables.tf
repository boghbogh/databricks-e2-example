variable "databricks_account_username" {
  type = string
  sensitive = true
}

variable "databricks_account_password" {
  type = string
  sensitive = true
}

variable "databricks_account_id" {
  type = string
  sensitive = true
}

variable "cross_account_role_arn" {
  type = string
  sensitive = true
}

variable "uc_role_arn" {
  type = string
  sensitive = true
}

variable "cmk_admin" {
  type = string
  sensitive = true
}

variable "resource_owner" {
  type = string
  sensitive = true
}

variable "vpc_cidr_range" {
  type = string
}

variable "private_subnets_cidr" {
  type = string
}

variable "public_subnets_cidr" {
  type = string
}

variable "firewall_subnets_cidr" {
  type = string
}

variable "privatelink_subnets_cidr" {
  type = string
}

variable "availability_zones" {
  type = string
}

variable "region" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "workspace_vpce_service" {
  type = string
}

variable "relay_vpce_service" {
  type = string
}

variable "metastore_url" {
  type = string
}

variable "control_plane_infra" {
  type = string
}

variable "firewall_allow_list" {
  type = string
}

variable "firewall_protocol_deny_list" {
  type = string
}