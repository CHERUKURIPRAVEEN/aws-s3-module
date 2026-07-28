###############################################
# S3 Bucket Replication Configuration
###############################################

resource "aws_s3_bucket_replication_configuration" "this" {

  count = local.replication_enabled ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  role = var.replication_role_arn


  dynamic "rule" {

    for_each = var.replication_rules


    content {

      id = rule.value.id

      status = rule.value.status


      #########################################
      # Filter
      #########################################

      dynamic "filter" {

        for_each = (
          try(rule.value.filter, null) != null
          ? [rule.value.filter]
          : []
        )

        content {

          prefix = try(filter.value.prefix, null)

        }

      }


      #########################################
      # Destination
      #########################################

      destination {

        bucket = rule.value.destination.bucket

        storage_class = try(
          rule.value.destination.storage_class,
          null
        )


        #######################################
        # Encryption Replication
        #######################################

        dynamic "encryption_configuration" {

          for_each = (
            try(
              rule.value.destination.encryption_configuration,
              null
            ) != null
            ? [rule.value.destination.encryption_configuration]
            : []
          )


          content {

            replica_kms_key_id = encryption_configuration.value.replica_kms_key_id

          }

        }


        #######################################
        # Account Ownership
        #######################################

        dynamic "access_control_translation" {

          for_each = (
            try(
              rule.value.destination.account,
              null
            ) != null
            ? [1]
            : []
          )


          content {

            owner = "Destination"

          }

        }

      }


      #########################################
      # Delete Marker Replication
      #########################################

      delete_marker_replication {

        status = try(
          rule.value.delete_marker_replication,
          "Disabled"
        )

      }

    }

  }


  depends_on = [
    aws_s3_bucket_versioning.this
  ]

}