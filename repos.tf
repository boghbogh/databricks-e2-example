resource "databricks_repo" "databricks_notebooks" {
  provider = databricks.created_workspace
  url = "https://github.com/andyweaves/databricks-notebooks.git"
}