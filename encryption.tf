###############################################
# S3 Bucket Server Side Encryption
###############################################

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {

  count  = var.create_bucket && var.enable_encryption ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  rule {
    bucket_key_enabled = var.bucket_key_enabled
    apply_server_side_encryption_by_default {
      sse_algorithm     = local.sse_algorithm
      kms_master_key_id = local.kms_master_key_id
    }

  }

}