output "alb_dns_name" {

  value = data.aws_lb.lb.dns_name

}

output "aws_route53_details" {

  value = data.aws_route53_zone.selected

}


output "cf_domain" {
  value = module.cf_distribution.domain_name
}

output "dist_arn" {
  value = module.cf_distribution.distribution_arn
}
