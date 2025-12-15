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
      "us-east-1b"
    ]
  }
}
data "aws_route53_zone" "hosted_zone_names" {
  name         = var.name
  private_zone = false
}

data "aws_acm_certificate" "ssl_cert_name" {
  domain   = var.name
  statuses = ["ISSUED"]
}