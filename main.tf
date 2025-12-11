module "ecr_image" {

  source        = "./modules/ecr"
  ecr_repo_name = var.ecr_repo_name
  repo_types    = var.repo_types

  scan_image_on_push = var.scan_image_on_push

}

import {

  id = "cat-blogs"
  to = module.ecr_image.aws_ecr_repository.repo


}


module "iam_oidc" {
  source      = "./modules/iam"
  role_name   = var.role_name
  policy_name = var.policy_name
  repo_name   = var.repo_name
  repo_owner  = var.repo_owner



}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.34"

  vpc_id     = data.aws_vpc.default_vpc.id
  subnet_ids = data.aws_subnets.default_subnets.ids

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  create_kms_key                = false
  kms_key_enable_default_policy = false
  cluster_encryption_config     = []


  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.small"]
    }
  }
}


module "aws_ec2_tag" {

  source = "./modules/vpc"

  subnet_ids = data.aws_subnets.default_subnets.ids

  subnet_tags = var.subnet_tags


}

/*module "aws_route53_record" {
  source = "./modules/route53"

  zone_id = data.aws_route53_zone.selected.zone_id

  for_each = aws_cloudfront_distribution.s3_distribution.aliases

  type = var.type

  ttl = var.ttl

  name = var.name

  dns_name    = data.aws_lb.lb.dns_name
  zone_id = data.aws_lb.lb.zone_id

}*/


module "s3_bucket_hosting" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.0"

  bucket = var.bucket_name_hosting

  object_ownership         = "BucketOwnerEnforced"
  control_object_ownership = true

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }


  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

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

module "cf_distribution" {
  source = "./modules/cloudfront"

  web_bucket_name          = module.s3_bucket_hosting.s3_bucket_id
  web_bucket_arn           = module.s3_bucket_hosting.s3_bucket_arn
  s3_bucket_website_domain = module.s3_bucket_hosting.s3_bucket_bucket_regional_domain_name
}



module "aws_route53_record" {
  name= var.name
  source        = "./modules/route53"
  route_zone_id = data.aws_route53_zone.selected.zone_id
  type          = "A"

  dns_name = module.cf_distribution.domain_name
  zone_id  = module.cf_distribution.hosted_zone_id
  ttl      = "300"
}

