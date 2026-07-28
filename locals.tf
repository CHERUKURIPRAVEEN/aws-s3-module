#########################################
# Local Values
#########################################
locals {
  # Encryption
  sse_algorithm     = (var.kms_key_arn != null ? "aws:kms" : "AES256")
  kms_master_key_id = (var.kms_key_arn != null ? var.kms_key_arn : null)

  # Versioning Status
  versioning_status = (var.enable_versioning ? "Enabled" : "Suspended")

  # MFA Delete Status
  mfa_delete_status = (var.mfa_delete ? "Enabled" : "Disabled")

  # Bucket Creation
  create_bucket = var.create_bucket ? 1 : 0

  # Logging Enabled
  logging_enabled = (var.enable_logging && var.logging_bucket != null)

  # Lifecycle Enabled
  lifecycle_enabled = (var.enable_lifecycle && length(var.lifecycle_rules) > 0)

  # Replication Enabled
  replication_enabled = (var.enable_replication && var.replication_role_arn != null && length(var.replication_rules) > 0)

  # Website Enabled
  website_enabled = var.website_enabled

  # CORS Enabled
  cors_enabled = (var.enable_cors && length(var.cors_rules) > 0)
}