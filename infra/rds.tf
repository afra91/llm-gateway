resource "aws_db_instance" "llm_gateway_db" {
  allocated_storage           = 6
  db_name                     = "llm_gateway_db"
  engine                      = "postgres"
  instance_class              = "db.t3.micro"
  manage_master_user_password = true
  username                    = "llm_gateway"
  db_subnet_group_name        = module.vpc.database_subnet_group_name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  storage_encrypted           = true
  skip_final_snapshot         = true
}

resource "aws_security_group" "rds" {
  name   = "llm-gateway-rds"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_postgres" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = module.eks.node_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
}
