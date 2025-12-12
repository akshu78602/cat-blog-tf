ecr_repo_name      = "cat-blogs"
repo_types         = "MUTABLE"
scan_image_on_push = true
bucket_name        = "qa-catblog-tfstate"
repo_name          = "cat-blog-tf"
repo_owner         = "akshu78602"
policy_name        = "test1"
role_name          = "abc"
cluster_name       = "test1"
cluster_role_name  = "EKSClusterRole"
name                = "littlecat.net"
ttl                 = "300"
type                = "A"
bucket_name_hosting = "blog-hosting-cat-1"

subnet_tags = {
  "env" : "qa",
  "kubernetes.io/cluster/test1" = "shared",
  "kubernetes.io/role/elb"      = "1"
}