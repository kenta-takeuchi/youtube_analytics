data "aws_secretsmanager_secret_version" "rds_credits" {
  secret_id = "${local.product_name}/mysql"
}

//data "aws_secretsmanager_secret_version" "account-credits" {
//  secret_id = "${local.product_name}/account"
//}