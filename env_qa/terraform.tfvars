ecr_repo_name        = "cat-blogs"
image_tag_mutability = "MUTABLE"
scan_image_on_push   = true
github_repo_name     = "cat-blog-tf"
repo_owner           = "akshu78602"
policy_name          = "ci_cd_access_policy"
role_name            = "ci_cd_role"
cluster_name         = "cat-blog"
name                 = "littlecat.net"
ttl                  = "300"
type                 = "A"
bucket_name_hosting  = "blog-hosting-cat-1"

subnet_tags = {
  "env" : "qa",
  "kubernetes.io/cluster/test1" = "shared",
  "kubernetes.io/role/elb"      = "1"
}