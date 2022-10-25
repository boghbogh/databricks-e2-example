output "databricks_host" {
  value = module.databricks_mws_workspace.workspace_url
}

output "databricks_token" {
  value     = databricks_token.pat.token_value
  sensitive = true
}