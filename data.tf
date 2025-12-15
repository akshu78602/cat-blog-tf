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
data "aws_route53_zone" "selected" {
  name         = var.name
  private_zone = false
}

data "aws_acm_certificate" "issued" {
  domain   = var.name
  statuses = ["ISSUED"]
}