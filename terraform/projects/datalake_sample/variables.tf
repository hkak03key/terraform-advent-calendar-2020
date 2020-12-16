variable "account_name" {
  type = string
}

variable "external_policies" {
  type    = map(any)
  default = {}
}

variable "delegate_identities" {
  type = object({
    write_to_default_bucket_iam_user = string
  })
}

