module "cat_blog_image" {
  source = "../modules/ecr"

  ecr_repo_name      = var.ecr_repo_name
  repo_types         = var.image_tag_mutability
  scan_image_on_push = var.scan_image_on_push
}

module "iam_oidc" {
  source = "../modules/iam"

  role_name   = var.role_name
  policy_name = var.policy_name
  repo_name   = var.github_repo_name
  repo_owner  = var.repo_owner
}

module "cat_blog_cluster" {
  source                               = "terraform-aws-modules/eks/aws"
  version                              = "18.31.2"
  cluster_name                         = var.cluster_name
  cluster_version                      = "1.34"
  vpc_id                               = data.aws_vpc.default_vpc.id
  subnet_ids                           = data.aws_subnets.default_subnets.ids
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  create_kms_key                       = false
  kms_key_enable_default_policy        = false
  cluster_encryption_config            = []

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.small"]
    }
  }
}

module "subnet_tagging" {
  source = "../modules/vpc_subnet_tagging"

  subnet_ids  = data.aws_subnets.default_subnets.ids
  subnet_tags = var.subnet_tags
}

module "cat_blog_s3_hosting" {
  source = "terraform-aws-modules/s3-bucket/aws"

  version                  = "4.1.0"
  bucket                   = var.bucket_name_hosting
  object_ownership         = "BucketOwnerEnforced"
  control_object_ownership = true
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning = {
    enabled = true
  }

  /*policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${var.bucket_name_hosting}/*"
      }
    ]
  })*/
}

module "s3_cf_distribution" {
  source = "../modules/cloudfront"

  web_bucket_name          = module.cat_blog_s3_hosting.s3_bucket_id
  web_bucket_arn           = module.cat_blog_s3_hosting.s3_bucket_arn
  s3_bucket_website_domain = module.cat_blog_s3_hosting.s3_bucket_bucket_regional_domain_name
  cert_arn                 = data.aws_acm_certificate.ssl_cert_name.arn
}

module "cloudfront_route53_record" {
  source = "../modules/route53"

  zone_id                = data.aws_route53_zone.hosted_zone_names.zone_id
  name                   = var.name
  type                   = var.type
  alias_name             = module.s3_cf_distribution.domain_name
  alias_zone_id          = module.s3_cf_distribution.hosted_zone_id
  evaluate_target_health = false
}
