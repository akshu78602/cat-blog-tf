resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "oac-${local.web_bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name              = local.s3_bucket_website_domain
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "s3-origin-${local.web_bucket_name}"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
}

data "aws_iam_policy_document" "blogbucketpolicybuilder" {
  statement {
    sid = "AllowCFRead"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${local.web_bucket_arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.s3_distribution.arn
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "bucketpolicy" {
  bucket = local.web_bucket_name
  policy = data.aws_iam_policy_document.blogbucketpolicybuilder.json
}

output "domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}


output "distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

output "hosted_zone_id" {
  description = "CloudFront Route53 hosted zone id"
  value       = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}

