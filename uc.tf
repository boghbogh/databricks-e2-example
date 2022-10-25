resource "aws_s3_bucket" "unity_catalog" {
  bucket = local.uc_bucketname
  acl    = "private"
  versioning {
    enabled = true
  }
  force_destroy = true
  tags = {
    Name = local.uc_bucketname
  }
}

resource "aws_s3_bucket_public_access_block" "unity_catalog" {
  bucket                  = aws_s3_bucket.unity_catalog.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [aws_s3_bucket.unity_catalog]
}

resource "databricks_metastore" "unity_catalog" {
  provider      = databricks.created_workspace
  name          = "${local.prefix}-${var.region}"
  storage_root  = "s3://${aws_s3_bucket.unity_catalog.id}/managed"
  owner         = var.databricks_account_username
  force_destroy = true
}

# resource "databricks_metastore_data_access" "unity_catalog" {
#   provider     = databricks.created_workspace
#   metastore_id = databricks_metastore.unity_catalog.id
#   name         = var.uc_role_arn
#   aws_iam_role {
#     role_arn = var.uc_role_arn
#   }
#   is_default = true
# }

# resource "databricks_metastore_assignment" "unity_catalog" {
#   workspace_id         = module.databricks_mws_workspace.workspace_id
#   metastore_id         = databricks_metastore.unity_catalog.id
#   default_catalog_name = "hive"
# }