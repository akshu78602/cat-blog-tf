locals {
  web_bucket_name          = var.web_bucket_name
  web_bucket_arn           = var.web_bucket_arn
  s3_bucket_website_domain = var.s3_bucket_website_domain
  s3_origin_id             = "s3-origin-${var.web_bucket_name}"
}

variable "web_bucket_name" {
  type = string
}

variable "web_bucket_arn" {
  type = string
}

variable "s3_bucket_website_domain" {
  type = string
}

variable "cert_arn" {
  type = string
}