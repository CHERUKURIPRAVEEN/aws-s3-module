/*
* AWS S3 Module
* Managed by Praveen Cherukuri(github.com/CHERUKURIPRAVEEN)
*/

##################################################################################################
#####################################   R53   ####################################################
##################################################################################################

resource "aws_s3_bucket" "this" {
  count         = local.create_bucket
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = local.tags

  lifecycle {

    precondition {
      condition     = var.bucket_name != ""
      error_message = "bucket_name cannot be empty."
    }

    precondition {
      condition     = length(var.bucket_name) >= 3
      error_message = "Bucket name must be at least 3 characters."
    }

    precondition {
      condition     = length(var.bucket_name) <= 63
      error_message = "Bucket name cannot exceed 63 characters."
    }
  }

}