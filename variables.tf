variable "region" {
  description = "region details"
  type        = string
  default     = "us-east-1"
}

variable "application" {
  description = "Application tag value for the EC2 instance. Minimum of 8 characters."
  type        = string

  validation {
    condition     = length(var.application) <= 7
    error_message = "application value should be maximum of 7 characters"
  }
}

variable "application_code" {
  description = "Application code for the EC2 instance. Minimum of 8 characters."
  type        = string

  validation {
    condition     = length(var.application_code) <= 3
    error_message = "application code should be maximum of 3 characters"
  }
}

variable "environment" {
  description = "Environment of the EC2 instance. Possible values: 'Dev','Qa','Stage','PreProd','Production'"
  type        = string
  default     = "Dev"

  validation {
    condition     = contains(["Dev", "Qa", "Stage", "PreProd", "Production"], var.environment)
    error_message = "Environment should be 'Dev','Qa','Stage','PreProd','Production'"
  }
}

variable "environment_code" {
  description = "Environment code for the EC2 instance. Possible values: 'Dev','Qa','Stage','PreProd','Production'"
  type        = string
  default     = "A1"

  validation {
    condition     = length(var.environment_code) == 2
    error_message = "Environment code like 'A1','S1','S2','SX','P1','P2','PX','PR','PD'"
  }
}

variable "tags" {
  description = "default tags"
  type        = map(string)
  default = {
    "env" = "NP"
  }
}

variable "project" {
  description = "Project for which EC2 instance is being created"
  type        = string
  default     = ""

  validation {
    condition     = length(var.project) <= 7 || var.project == ""
    error_message = "Project value should be maximum of 7 characters or empty"
  }
}

variable "owner" {
  description = "Email address of the EC2 instance owner."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9._%+-]+@veen\\.com$", var.owner))
    error_message = "Owner email must be a valid @veen.com address."
  }
}

variable "app_owner" {
  description = "Email address of the application owner."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9._%+-]+@veen\\.com$", var.app_owner))
    error_message = "Application owner email must be a valid @veen.com address."
  }
}

variable "description" {
  description = "Description for which SG is being created"
  type        = string
}

#########################################
# General
#########################################

variable "create_bucket" {
  description = "Whether to create the S3 bucket"
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "Name of the S3 bucket"

  type = string

  validation {
    condition = (
      length(var.bucket_name) >= 3 &&
      length(var.bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name)) &&
      !can(regex("\\.\\.", var.bucket_name)) &&
      !can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", var.bucket_name))
    )

    error_message = <<EOT
                        Bucket name must:
                        - be 3-63 characters
                        - contain only lowercase letters, numbers, '.' and '-'
                        - start and end with a letter or number
                        - not contain consecutive periods
                        - not be formatted as an IP address
                      EOT
  }
}

variable "force_destroy" {
  description = "Allow Terraform to delete non-empty bucket"

  type    = bool
  default = false
}

#########################################
# Versioning
#########################################

variable "enable_versioning" {
  description = "Enable bucket versioning"

  type    = bool
  default = true
}

variable "mfa_delete" {
  description = "Enable MFA delete"

  type    = bool
  default = false
}

#########################################
# Encryption
#########################################

variable "enable_encryption" {
  description = "Enable default encryption"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "Customer managed KMS Key ARN"
  type        = string
  default     = null
  validation {
    condition     = (var.kms_key_arn == null || can(regex("^arn:aws:kms:", var.kms_key_arn)))
    error_message = "kms_key_arn must be a valid AWS KMS ARN."
  }

}

variable "bucket_key_enabled" {
  description = "Enable Bucket Keys to reduce KMS cost"
  type        = bool
  default     = true
}

#########################################
# Ownership Controls
#########################################

variable "object_ownership" {

  description = "Object ownership"

  type = string

  default = "BucketOwnerEnforced"

  validation {
    condition = contains([
      "BucketOwnerPreferred",
      "BucketOwnerEnforced",
      "ObjectWriter"
    ], var.object_ownership)

    error_message = "Valid values are BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter."
  }
}

#########################################
# Public Access Block
#########################################

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

#########################################
# Logging
#########################################

variable "enable_logging" {
  type    = bool
  default = false
}

variable "logging_bucket" {
  type    = string
  default = null
  validation {
    condition     = (!var.enable_logging || var.logging_bucket != null)
    error_message = "logging_bucket must be specified when logging is enabled."
  }
}

variable "logging_prefix" {
  type    = string
  default = "logs/"
}

#########################################
# Lifecycle
#########################################

variable "enable_lifecycle" {
  type    = bool
  default = false
}

variable "lifecycle_rules" {
  description = "Lifecycle configuration rules"

  type = list(object({
    id     = string
    status = string

    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))

    expiration = optional(object({
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))

    transitions = optional(list(object({
      days          = number
      storage_class = string
    })))

    noncurrent_version_transitions = optional(list(object({
      noncurrent_days = number
      storage_class   = string
    })))

    noncurrent_version_expiration = optional(object({
      noncurrent_days = number
    }))

    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }))
  }))

  default = []
}

#########################################
# CORS
#########################################

variable "enable_cors" {
  type    = bool
  default = false
}

variable "cors_rules" {
  description = "S3 CORS rules"
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))

  default = []
}

#########################################
# Website Hosting
#########################################

variable "website_enabled" {
  type    = bool
  default = false
}

variable "index_document" {
  type    = string
  default = "index.html"
  validation {
    condition     = (!var.website_enabled || length(var.index_document) > 0)
    error_message = "index_document cannot be empty."
  }
}

variable "error_document" {
  type    = string
  default = "error.html"
}

#########################################
# Event Notifications
#########################################

variable "eventbridge_enabled" {
  type    = bool
  default = false
}

#########################################
# Replication
#########################################

variable "enable_replication" {
  type    = bool
  default = false
}

variable "replication_role_arn" {
  type    = string
  default = null
  validation {
    condition     = (length(var.replication_rules) == 0 || var.replication_role_arn != null)
    error_message = "replication_role_arn is required when replication_rules are configured."
  }
}

variable "replication_rules" {

  description = "S3 replication rules"

  type = list(object({
    id     = string
    status = string
    filter = optional(object({
      prefix = optional(string)
    }))

    destination = object({
      bucket        = string
      storage_class = optional(string)
      encryption_configuration = optional(object({
        replica_kms_key_id = string
      }))
      account = optional(string)
    })
    delete_marker_replication = optional(string)
  }))
  default = []

}

variable "lambda_notifications" {
  type    = list(any)
  default = []
}

variable "sns_notifications" {
  type    = list(any)
  default = []
}

variable "sqs_notifications" {
  type    = list(any)
  default = []
}

#########################################
# Website Hosting
#########################################

variable "routing_rules" {
  description = "Website routing rules"
  type = list(object({
    condition = object({
      key_prefix_equals               = optional(string)
      http_error_code_returned_equals = optional(string)
    })
    redirect = object({
      host_name               = optional(string)
      replace_key_prefix_with = optional(string)
      replace_key_with        = optional(string)
      http_redirect_code      = optional(string)
    })
  }))
  default = []
}

#########################################
# Bucket Policy
#########################################

variable "enforce_ssl_requests" {
  description = "Deny all non HTTPS S3 requests"
  type        = bool
  default     = true
}

variable "bucket_policy_statements" {
  description = "Custom S3 bucket policy statements"
  type = list(object({
    sid       = optional(string)
    effect    = string
    actions   = list(string)
    resources = list(string)
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
  default = []
}