
locals {
  subnet_tags = flatten([
    for subnet in var.subnet_ids : [
      for key, value in var.subnet_tags : {
        id          = "${subnet}-${key}"
        resource_id = subnet
        key         = key
        value       = value
      }
    ]
  ])
}


resource "aws_ec2_tag" "tags" {
  for_each = {
    for t in local.subnet_tags : t.id => t
  }

  resource_id = each.value.resource_id
  key         = each.value.key
  value       = each.value.value
}
