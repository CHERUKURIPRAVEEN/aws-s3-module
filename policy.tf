###############################################
# S3 Bucket Policy
###############################################

data "aws_iam_policy_document" "secure_transport" {

  count = (var.create_bucket && var.enforce_ssl_requests) ? 1 : 0
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

###############################################
# Custom Bucket Policy
###############################################

data "aws_iam_policy_document" "custom" {

  count = (var.create_bucket && length(var.bucket_policy_statements) > 0) ? 1 : 0

  dynamic "statement" {
    for_each = var.bucket_policy_statements
    content {
      sid       = try(statement.value.sid, null)
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }

      }
    }
  }
}

###############################################
# Combine Policies
###############################################

data "aws_iam_policy_document" "combined" {

  count = (var.create_bucket && (var.enforce_ssl_requests || length(var.bucket_policy_statements) > 0)) ? 1 : 0

  source_policy_documents = compact([
    try(data.aws_iam_policy_document.secure_transport[0].json, null),
    try(data.aws_iam_policy_document.custom[0].json, null)
  ])
}

###############################################
# Apply Bucket Policy
###############################################

resource "aws_s3_bucket_policy" "this" {
  count  = (var.create_bucket && (var.enforce_ssl_requests || length(var.bucket_policy_statements) > 0)) ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.combined[0].json
}