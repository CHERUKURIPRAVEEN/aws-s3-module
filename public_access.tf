###############################################
# S3 Bucket Public Access Block
###############################################

resource "aws_s3_bucket_public_access_block" "this" {

  count  = var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  depends_on = [
    aws_s3_bucket_ownership_controls.this
  ]
}