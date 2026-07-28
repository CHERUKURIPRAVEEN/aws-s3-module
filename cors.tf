###############################################
# S3 Bucket CORS Configuration
###############################################

resource "aws_s3_bucket_cors_configuration" "this" {
  count = (
    var.create_bucket &&
    var.enable_cors &&
    length(var.cors_rules) > 0
  ) ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}