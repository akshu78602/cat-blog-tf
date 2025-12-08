data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }




  filter {
    name = "availability-zone"
    values = [
      "us-east-1a",
      "us-east-1b",
      "us-east-1c",
      "us-east-1d",
      "us-east-1f",
    ]
  }
}

data "aws_lb" "lb" {

  name = "k8s-default-catblogl-997762d507"


}

data "aws_route53_zone" "selected" {
  name         = var.name
  private_zone = false
}