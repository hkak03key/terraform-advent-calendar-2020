#=================================
# iam policy
#=================================
resource "aws_iam_policy" "s3_full_bucket_iam_policies" {
  for_each = toset([
    aws_s3_bucket.default.bucket,
  ])

  name        = "s3-full-${replace(each.value, "*", "@")}"
  path        = "/"
  description = "s3 full access to ${replace(each.value, "*", "@")}${replace(each.value, "*", "") != each.value ? ". @=asterisk" : ""}"
  policy = templatefile(
    "${path.module}/../../templates/s3_access_to_bucket_iam_policy.json.tpl",
    {
      access_type = "full"
      bucket      = each.value
    }
  )
}

resource "aws_iam_policy" "s3_read_bucket_iam_policies" {
  for_each = toset([
    aws_s3_bucket.default.bucket,
  ])

  name        = "s3-read-${replace(each.value, "*", "@")}"
  path        = "/"
  description = "s3 read access to ${replace(each.value, "*", "@")}${replace(each.value, "*", "") != each.value ? ". @=asterisk" : ""}"
  policy = templatefile(
    "${path.module}/../../templates/s3_access_to_bucket_iam_policy.json.tpl",
    {
      access_type = "read"
      bucket      = each.value
    }
  )
}


#=================================
# delegate
#=================================
#---------------------------------
# iam policy attachment
resource "aws_iam_user_policy_attachment" "write_to_default_bucket" {
  for_each = {
    for p in flatten([
      aws_iam_policy.s3_full_bucket_iam_policies[aws_s3_bucket.default.bucket],
    ]) :
    p.name => p.arn
  }
  user       = var.delegate_identities["write_to_default_bucket_iam_user"]
  policy_arn = each.value
}

