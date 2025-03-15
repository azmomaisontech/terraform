variable "environment" {
  description = "environment of the s3 bucket i.e dev, stage, prod"
  type    = string
}

variable "product_name" {
    description = "product name"
    type        = string
}

variable "versioning" {
  description = "enable s3 versioning"
  default     = true
}


variable "public_access_block" {
  description = "values for the public access block"
  type        = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}


variable "aliases" {
  description = "List of aliases for the CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type = object({
    acm_certificate_arn            = optional(string)
    cloudfront_default_certificate = optional(bool)
    iam_certificate_id             = optional(string)
    minimum_protocol_version       = optional(string)
    ssl_support_method             = optional(string)
  })
  default = {
    cloudfront_default_certificate = true
  }
}

