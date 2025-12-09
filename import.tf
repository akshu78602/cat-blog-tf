import {
  id = "https://token.actions.githubusercontent.com"
  to = module.iam_oidc.aws_iam_openid_connect_provider.default
}

import {
  id = "abc"
  to = module.iam_oidc.aws_iam_role.role
}


import {
  id = "arn:aws:iam::424851482428:policy/test1"
  to = module.iam_oidc.aws_iam_policy.policy
}

