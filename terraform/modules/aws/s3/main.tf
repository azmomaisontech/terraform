locals {
  s3_assets_origin_id          = "assetsOrigin"
  wafv2_web_acl_name           = "${var.product_name}-wafv2-web-acl-${var.environment}"
}

#######################################
# S3 Bucket (assets)
#######################################

resource "aws_s3_bucket" "this" {
  bucket = "${var.product_name}-s3-bucket-${var.environment}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    "name"        = "Bucket for ${var.product_name} MFE files"
    "environment" = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.public_access_block.block_public_acls
  block_public_policy     = var.public_access_block.block_public_policy
  ignore_public_acls      = var.public_access_block.ignore_public_acls
  restrict_public_buckets = var.public_access_block.restrict_public_buckets
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/", "${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = flatten([
        aws_cloudfront_origin_access_identity.this.iam_arn
      ])
    }
  }
}

#######################################
# S3 CloudFront Distribution (assets)
#######################################
resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "Origin Access Identity for ${var.product_name} MFE files"
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true
  aliases = var.aliases
  web_acl_id = var.vpn_protected ? aws_wafv2_web_acl.this[0].arn : null

  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = local.s3_assets_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_assets_origin_id

    cache_policy_id = data.aws_cloudfront_cache_policy.Managed-CachingDisabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.Managed-CORS-S3Origin.id

    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers_policy.id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = lookup(var.viewer_certificate, "acm_certificate_arn", null)
    cloudfront_default_certificate = lookup(var.viewer_certificate, "cloudfront_default_certificate", null)
    iam_certificate_id             = lookup(var.viewer_certificate, "iam_certificate_id", null)

    minimum_protocol_version = lookup(var.viewer_certificate, "minimum_protocol_version", "TLSv1")
    ssl_support_method       = lookup(var.viewer_certificate, "ssl_support_method", null)
  }

  tags = {
    "environment" = var.environment
  }
}

data "aws_cloudfront_cache_policy" "Managed-CachingDisabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "Managed-CORS-S3Origin" {
  name = "Managed-CORS-S3Origin"
}


resource "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name = "security-headers-policy"

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override = true
    }

    referrer_policy {
      referrer_policy = "same-origin"
      override = true
    }

    xss_protection {
      mode_block = true
      protection = true
      override = true
    }

    strict_transport_security {
      access_control_max_age_sec = "63072000"
      include_subdomains = true
      preload = true
      override = true
    }
  }
}

#######################################
# Wafv2 Web ACL
#######################################
resource "aws_wafv2_web_acl" "this" {
  name  = local.wafv2_web_acl_name
  count = (var.vpn_protected || var.environment == "prod") ? 1 : 0
  description = "Only allowing access to VPN connected users"
  scope       = var.cloudfront_scope

  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = var.environment == "" ? "${var.waf_name}-block" : "${var.waf_name}-${var.environment}-block"
    sampled_requests_enabled   = false
  }

  rule {
    name     = "vpn_rule_${var.environment}"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.vpn_ip[0].arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${var.waf_name}-allow"
      sampled_requests_enabled   = false
    }
  }
}


#######################################
# Wafv2 IP Set
#######################################
resource "aws_wafv2_ip_set" "vpn_ip" {
  count = (var.vpn_protected || var.environment == "prod") ? 1 : 0
  name               = "ipset"
  description        = "IP range for VPNs"
  ip_address_version = "IPV4"
  scope              = var.cloudfront_scope
  addresses          = var.allowed_ip_ranges

  tags = {
    "environment" = var.environment
  }
}
