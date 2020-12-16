#=================================
# system user
#=================================
#---------------------------------
# iam user
# notice: secretは手動作成
resource "aws_iam_user" "system_user" {
  name = "${local.resource_prefix}-system-user"
}

#---------------------------------
# iam policy attachment
resource "aws_iam_user_policy_attachment" "system_user" {
  for_each = {
    for p in flatten([
      # tf 0.12.21: lookupで書こうとするとエラーになる
      contains(keys(var.external_policies), "system_user") ? var.external_policies["system_user"] : []
    ]) :
    p.name => p.arn
  }
  user       = aws_iam_user.system_user.name
  policy_arn = each.value
}

