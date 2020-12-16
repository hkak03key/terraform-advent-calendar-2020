variable "account_name" {
  type = string
}

variable "external_policies" {
  type    = map(any)
  default = {}
}

