
#---------------------------------
# connect_to_onpre
module "connect_to_onpre" {
  source       = "../../projects/connect_to_onpre"
  account_name = var.account_name
  external_policies = {
    databricks_role = [
      module.adhoc_sample.s3_read_bucket_iam_policies["etl"],
    ]
  }
}

#---------------------------------
# datalake_sample
module "datalake_sample" {
  source       = "../../projects/datalake_sample"
  account_name = var.account_name
  delegate_identities = {
    write_to_default_bucket_iam_user = module.connect_to_onpre.iam_user.name
  }
}

#---------------------------------
# adhoc
module "adhoc_sample" {
  source       = "../../projects/adhoc_sample"
  account_name = var.account_name
  external_policies = {
    databricks_role = [
      module.datalake_sample.s3_read_bucket_iam_policies[""],
    ]
    redash_user = [
      module.datalake_sample.s3_read_bucket_iam_policies[""],
    ]
  }
}

