variable "subnet_tags" {
  type = map(string)
  default = {
    "kubernetes.io/cluster/my-eks" = "shared"
    "kubernetes.io/role/elb"       = "1"
  }
}

variable "subnet_ids" {

  type = list(string)


}