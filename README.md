terraform-aws-s3/
│
├── versions.tf
├── variables.tf
├── locals.tf
├── main.tf
├── encryption.tf
├── versioning.tf
├── ownership.tf
├── public_access.tf
├── lifecycle.tf
├── logging.tf
├── replication.tf
├── notification.tf
├── website.tf
├── cors.tf
├── policy.tf
├── outputs.tf
├── README.md
└── examples/

This version follows enterprise Terraform practices:

Strong validation for bucket names.
Secure defaults:
Versioning enabled.
Encryption enabled.
Public access blocked.
force_destroy = false.
Optional features (logging, lifecycle, replication, website hosting) are disabled by default and enabled explicitly.
Flexible tags map for organizational standards.
any is used for complex nested objects initially; later we can replace these with strict object types for even stronger validation.

Instead of repeating logic like this everywhere:
count = var.enable_versioning ? 1 : 0

algorithm = var.kms_key_arn != null ? "aws:kms" : "AES256"

count = local.create_bucket
algorithm = local.sse_algorithm
tags = local.tags

This has several advantages:

Single place to update logic.
Less duplicated code.
Easier maintenance and testing.
Cleaner resource definitions.
Consistent behavior across all feature files.

| File               | Resource                                             |
| ------------------ | ---------------------------------------------------- |
| `main.tf`          | `aws_s3_bucket`                                      |
| `versioning.tf`    | `aws_s3_bucket_versioning`                           |
| `encryption.tf`    | `aws_s3_bucket_server_side_encryption_configuration` |
| `ownership.tf`     | `aws_s3_bucket_ownership_controls`                   |
| `public_access.tf` | `aws_s3_bucket_public_access_block`                  |
| `logging.tf`       | `aws_s3_bucket_logging`                              |
| `lifecycle.tf`     | `aws_s3_bucket_lifecycle_configuration`              |
| `website.tf`       | `aws_s3_bucket_website_configuration`                |
| `cors.tf`          | `aws_s3_bucket_cors_configuration`                   |
| `notification.tf`  | `aws_s3_bucket_notification`                         |
| `replication.tf`   | `aws_s3_bucket_replication_configuration`            |
| `policy.tf`        | `aws_s3_bucket_policy`                               |
