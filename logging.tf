###############################################
# S3 Bucket Access Logging
###############################################

resource "aws_s3_bucket_logging" "this" {

  count         = local.logging_enabled ? 1 : 0
  bucket        = aws_s3_bucket.this[0].id
  target_bucket = var.logging_bucket
  target_prefix = var.logging_prefix

}