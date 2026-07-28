###############################################
# S3 Bucket Outputs
###############################################

output "bucket_id" {
  description = "S3 bucket ID"
  value       = try(aws_s3_bucket.this[0].id, null)
}

output "bucket_name" {
  description = "S3 bucket name"
  value       = try(aws_s3_bucket.this[0].bucket, null)
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = try(aws_s3_bucket.this[0].arn, null)
}

###############################################
# Bucket Domain Outputs
###############################################

output "bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = try(aws_s3_bucket.this[0].bucket_domain_name, null)
}

output "bucket_regional_domain_name" {
  description = "Regional S3 bucket domain name"
  value       = try(aws_s3_bucket.this[0].bucket_regional_domain_name, null)
}


output "hosted_zone_id" {
  description = "Route53 hosted zone ID for S3"
  value       = try(aws_s3_bucket.this[0].hosted_zone_id, null)
}

###############################################
# Region
###############################################

output "bucket_region" {
  description = "AWS region where bucket exists"
  value       = try(aws_s3_bucket.this[0].region, null)
}

###############################################
# Website Outputs
###############################################

output "website_endpoint" {
  description = "S3 website endpoint"
  value       = try(aws_s3_bucket_website_configuration.this[0].website_endpoint, null)
}

output "website_domain" {
  description = "S3 website domain"
  value       = try(aws_s3_bucket_website_configuration.this[0].website_domain, null)
}

###############################################
# Encryption Outputs
###############################################

output "kms_key_id" {
  description = "KMS key used for encryption"
  value       = var.kms_key_arn
}

###############################################
# Logging Outputs
###############################################

output "logging_enabled" {
  description = "Whether S3 access logging is enabled"
  value       = local.logging_enabled
}

###############################################
# Versioning Outputs
###############################################
output "versioning_enabled" {
  description = "Whether versioning is enabled"
  value       = var.enable_versioning
}