terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
    }
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region  
  default_tags {
    tags = {
    Owner = var.resource_owner
    }
  }
}

provider "databricks" {
  alias    = "mws"
  host     = "https://accounts.cloud.databricks.com"
  username = var.databricks_account_username
  password = var.databricks_account_password
  auth_type =  "basic"
}

provider "databricks" {
  alias    = "created_workspace"
  host     = module.databricks_mws_workspace.workspace_url
  username = var.databricks_account_username
  password = var.databricks_account_password
  auth_type =  "basic"
}