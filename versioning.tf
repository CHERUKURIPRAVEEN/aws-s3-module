resource "aws_s3_bucket_versioning" "this" {
  count  = var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  versioning_configuration {
    status     = local.versioning_status
    mfa_delete = local.mfa_delete_status
  }

}