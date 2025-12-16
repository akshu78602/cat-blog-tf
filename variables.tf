variable "ecr_repo_name" {
  type        = string
  description = "name of repo"
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "weather the repo should be mutable or immutable "
}

variable "scan_image_on_push" {
  type        = bool
  default     = true
  description = "scans images on push for vurnabilities"
}

variable "acl" {
  type    = string
  default = "private"
}

variable "role_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "repo_owner" {
  type = string
}

variable "github_repo_name" {
  type = string
}

variable "subnet_tags" {
  type = map(string)

  default = {
    "kubernetes.io/cluster/my-eks" = "shared"
    "kubernetes.io/role/elb"       = "1"
  }
}

variable "bucket_name_hosting" {
  type = string
}

variable "name" {
  type = string
}

variable "type" {
  type    = string
  default = "A"
}

variable "cluster_name" {
  type = string
}