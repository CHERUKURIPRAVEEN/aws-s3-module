#########################################
# Website Hosting
#########################################

resource "aws_s3_bucket_website_configuration" "this" {
  count  = (var.create_bucket && var.website_enabled) ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  index_document { suffix = var.index_document }
  error_document { key = var.error_document }

  dynamic "routing_rule" {
    for_each = var.routing_rules
    content {
      condition {
        key_prefix_equals               = try(routing_rule.value.condition.key_prefix_equals, null)
        http_error_code_returned_equals = try(routing_rule.value.condition.http_error_code_returned_equals, null)
      }
      redirect {
        host_name               = try(routing_rule.value.redirect.host_name, null)
        replace_key_prefix_with = try(routing_rule.value.redirect.replace_key_prefix_with, null)
        replace_key_with        = try(routing_rule.value.redirect.replace_key_with, null)
        http_redirect_code      = try(routing_rule.value.redirect.http_redirect_code, null)
      }
    }
  }
}