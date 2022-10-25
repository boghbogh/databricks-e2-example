variable "bucket_name" {
  type = string
}

variable "cross_account_role_arn" {
  type = string
}

variable "managed_services_cmk" { 
}

variable "workspace_storage_cmk" {
}

variable "databricks_account_id" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "backend_rest"{
  type = string
}

variable "backend_relay" {
  type = string
}