resource "aws_db_subnet_group" "vprofile-rds-subgrp" {
  name       = "vprofile-rds-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]

  tags = {
    Name = "subnet group for RDS"
  }
}

resource "aws_elasticache_subnet_group" "vprofile-ecache-subgrp" {
  name       = "vprofile-ecache-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  tags = {
    Name = "subnet group for Elastic Cache"
  }
}

resource "aws_db_instance" "vprofile-rds" {
  allocated_storage      = 20
  db_name                = var.dbname
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.USERNAME
  password               = var.dbpass
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  multi_az               = "false"
  vpc_security_group_ids = [module.vprofile-basckend-secgp.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.vprofile-rds-subgrp.name
}


resource "aws_elasticache_cluster" "cprofile-cache" {
  cluster_id           = "vprofile-cache"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.4"
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.vprofile-ecache-subgrp.name
  security_group_ids   = [module.vprofile-basckend-secgp.security_group_id]
}

resource "aws_mq_broker" "vprofile-rmq" {
  broker_name = "vprofile-rmq"

  # configuration {
  #   id       = aws_mq_configuration.test.id
  #   revision = aws_mq_configuration.test.latest_revision
  # }
  auto_minor_version_upgrade = true
  engine_type        = "RabbitMQ"
  engine_version     = "5.17.6"
  storage_type       = "ebs"
  host_instance_type = "mq.t3.micro"
  security_groups    = [module.vprofile-basckend-secgp.security_group_id]
  subnet_ids         = [module.vpc.private_subnets[0]]
  user {
    username = var.rmquser
    password = var.rmqpass
  }
}