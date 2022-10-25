data "databricks_spark_version" "latest" {
  provider = databricks.created_workspace
  depends_on = [module.databricks_mws_workspace]
}

data "databricks_node_type" "smallest" {
  provider   = databricks.created_workspace
  local_disk = true
  depends_on = [module.databricks_mws_workspace]
}

resource "databricks_cluster" "initial_cluster" {
  node_type_id = data.databricks_node_type.smallest.id
  provider = databricks.created_workspace
  depends_on = [module.databricks_mws_workspace, aws_networkfirewall_firewall.nfw]
  cluster_name            = "${local.prefix}-cluster"
  spark_version           = data.databricks_spark_version.latest.id
  autotermination_minutes = 30
  autoscale {
    min_workers = 2
    max_workers = 8
  }
  custom_tags = {
    "created_by" = "Terraform"
  }
  data_security_mode = "SINGLE_USER"
  single_user_name   = var.databricks_account_username
}