terraform import \
  'module.cat_blog_cluster.aws_cloudwatch_log_group.this[0]' \
  '/aws/eks/cat-blog/cluster'
