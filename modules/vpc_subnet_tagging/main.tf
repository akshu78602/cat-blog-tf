resource "aws_ec2_tag" "tags" {
  resource_id = each.value.resource_id
  key         = each.value.key
  value       = each.value.value

  for_each = {
    for t in local.subnet_tags : t.id => t
  }

}
