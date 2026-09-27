resource "aws_elasticache_replication_group" "cache" {
  replication_group_id = "cache"
  description          = "Valkey cache"
  engine               = "valkey"
  engine_version       = "9.1"
  node_type            = "cache.t4g.micro"
  num_cache_clusters   = 1
  parameter_group_name = "default.valkey9"
  port                 = 6379
  subnet_group_name    = module.vpc.elasticache_subnet_group_name
  security_group_ids   = [aws_security_group.cache.id]
}

resource "aws_security_group" "cache" {
  name   = "llm-gateway-cache"
  vpc_id = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_cache" {
  security_group_id            = aws_security_group.cache.id
  referenced_security_group_id = module.eks.node_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 6379
  to_port                      = 6379
}
