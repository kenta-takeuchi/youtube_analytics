locals {
  rds_credits = jsondecode(
    data.aws_secretsmanager_secret_version.rds_credits.secret_string
  )
}

resource "aws_db_subnet_group" "this" {
  name       = "practice"
  subnet_ids = [aws_subnet.private_0.id, aws_subnet.private_1.id]
}

resource "aws_db_instance" "this" {
  identifier                 = local.product_name
  engine                     = "postgres"
  engine_version             = "12.4"
  instance_class             = "db.t3.micro"
  allocated_storage          = 20
  max_allocated_storage      = 100
  storage_type               = "gp2"
  storage_encrypted          = true
  kms_key_id                 = aws_kms_key.this.arn
  username                   = local.rds_credits.USERNAME
  password                   = local.rds_credits.PASSWORD
  multi_az                   = true
  publicly_accessible        = false
  backup_window              = "09:10-09:40"
  backup_retention_period    = 10
  maintenance_window         = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade = false
  deletion_protection        = true
  skip_final_snapshot        = false
  port                       = 5432
  apply_immediately          = false
  vpc_security_group_ids     = [module.mysql_sg.security_group_id]

  lifecycle {
    ignore_changes = [password]
  }
}

module "mysql_sg" {
  source      = "./security_group"
  name        = "mysql-sg"
  vpc_id      = aws_vpc.this.id
  port        = 5432
  cidr_blocks = [aws_vpc.this.cidr_block]
}