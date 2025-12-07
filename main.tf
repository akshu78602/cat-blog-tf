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