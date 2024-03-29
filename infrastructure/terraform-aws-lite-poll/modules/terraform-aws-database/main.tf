resource "aws_security_group" "db_security_group" {
  name = "lite-poll-db-security-group"
  description = "lite poll database security group"
  vpc_id = var.database_vpc_id
  
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "lite_poll" {
  name       = "lite_poll"
  subnet_ids = var.database_subnets_ids

  tags = {
    Name = "lite_poll"
  }
}

resource "aws_db_instance" "lite_poll" {
  identifier             = "lite-poll-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.2"

  username               = "admin_user"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.lite_poll.name
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  parameter_group_name   = aws_db_parameter_group.lite_poll.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_db_parameter_group" "lite_poll" {
  name   = "lite-poll"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}
