resource "aws_s3_bucket_ownership_controls" "this" {

  count  = var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  rule {
    object_ownership = var.object_ownership
  }

}