###############################################
# S3 Bucket Lifecycle Configuration
###############################################

resource "aws_s3_bucket_lifecycle_configuration" "this" {

  count  = local.lifecycle_enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status
      #########################################
      # Filter
      #########################################
      dynamic "filter" {
        for_each = rule.value.filter != null ? [rule.value.filter] : []
        content {
          prefix = try(filter.value.prefix, null)
        }
      }

      #########################################
      # Expiration
      #########################################

      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [rule.value.expiration] : []
        content {
          days = try(expiration.value.days, null)
          expired_object_delete_marker = try(
            expiration.value.expired_object_delete_marker,
            null
          )
        }
      }

      #########################################
      # Transition
      #########################################

      dynamic "transition" {
        for_each = try(rule.value.transitions, [])
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      #########################################
      # Noncurrent Version Transition
      #########################################

      dynamic "noncurrent_version_transition" {
        for_each = try(rule.value.noncurrent_version_transitions, [])
        content {
          noncurrent_days = noncurrent_version_transition.value.noncurrent_days
          storage_class   = noncurrent_version_transition.value.storage_class
        }
      }

      #########################################
      # Noncurrent Version Expiration
      #########################################

      dynamic "noncurrent_version_expiration" {
        for_each = (
          rule.value.noncurrent_version_expiration != null
          ? [rule.value.noncurrent_version_expiration]
          : []
        )

        content {
          noncurrent_days = noncurrent_version_expiration.value.noncurrent_days
        }
      }

      #########################################
      # Abort Multipart Upload
      #########################################

      dynamic "abort_incomplete_multipart_upload" {

        for_each = (
          rule.value.abort_incomplete_multipart_upload != null
          ? [rule.value.abort_incomplete_multipart_upload]
          : []
        )

        content {
          days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
        }
      }
    }
  }
}