resource "aws_security_group" "ecs_security_group" {
  name = "lite-poll-ecs-security-group"
  description = "lite poll ecs security group"
  vpc_id = var.vpc_id
  
  # ingress rule of instance allows the load balancer to hit on any port of the instances
  # because each time container got diff port. So we can’t decide which ports the new container holds
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [var.loadbalancer_security_group_id]
  }

  egress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "default" {
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.202*-x86_64-ebs"]
  }

  most_recent = true
  owners      = ["amazon"]
}

data "template_file" "user_data" {
  template = file("modules/terraform-aws-service/user_data.tpl")
  vars = {
    NEW_RELIC_API_KEY = var.new_relic_config.api_key
    NEW_RELIC_ACCOUNT_ID = var.new_relic_config.account_id
  }
}

resource "aws_launch_configuration" "ecs_launch_config" {
  name_prefix="lite-poll"
  image_id = data.aws_ami.default.id
  iam_instance_profile = var.iam_instance_profile_name
  security_groups = [aws_security_group.ecs_security_group.id]
  user_data = data.template_file.user_data.rendered
  instance_type = "t2.micro"
  associate_public_ip_address = true
}

resource "aws_autoscaling_group" "default" {
  health_check_type = "EC2"
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  max_size = 4
  min_size = 2
  name = "auto-scaling-group"

  tag {
    key = "Env"
    propagate_at_launch = true
    value = "production"
  }

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "lite-poll"
  }

  # target_group_arns = var.scaling_group_arns
  termination_policies = ["OldestInstance"]

  vpc_zone_identifier = var.subnets_ids
}

resource "aws_ecs_cluster" "cluster" {
  name = "lite-poll-cluster"
}

data "template_file" "task_definition_template" {
  template = file("modules/terraform-aws-service/task_definition.json.tpl")
  vars = {
    REPOSITORY_URL = replace(var.image_repo_url, "https://", "")
    DB_HOST = var.db_config.host,
    DB_USER = var.db_config.user,
    DB_PASSWORD = var.db_config.password,
    DB_PORT = var.db_config.port,
    NEW_RELIC_LICENSE_KEY = var.new_relic_config.license_key
  }
}

data "template_file" "db_prepare_task_definition_template" {
  template = file("modules/terraform-aws-service/db_prepare_task_definition.json.tpl")
  vars = {
    REPOSITORY_URL = replace(var.image_repo_url, "https://", "")
    DB_HOST = var.db_config.host,
    DB_USER = var.db_config.user,
    DB_PASSWORD = var.db_config.password,
    DB_PORT = var.db_config.port,
    NEW_RELIC_LICENSE_KEY = var.new_relic_config.license_key
  }
}

data "template_file" "newrelic_infra_task_definition" {
  template = file("modules/terraform-aws-service/newrelic_integration.json.tpl")
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "worker"
  container_definitions = data.template_file.task_definition_template.rendered
}

resource "aws_ecs_task_definition" "db_prepare_task_definition" {
  family                = "db_prepare"
  container_definitions = data.template_file.db_prepare_task_definition_template.rendered
}

resource "aws_ecs_task_definition" "newrelic_infra_task_definition" {
  family = "newrelic-infra"
  container_definitions = data.template_file.newrelic_infra_task_definition.rendered
  requires_compatibilities = ["EC2"]
  network_mode = "host"
  execution_role_arn = var.role_arn
  volume {
    name = "host_root_fs"
    host_path = "/"
  }

  volume {
    name = "docker_socket"
    host_path = "/var/run/docker.sock"
  }
}

resource "aws_ecs_service" "worker" {
  name            = "worker"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1

  load_balancer {
    target_group_arn = var.service_target_group_arn
    container_name = "worker"
    container_port = 3000
  }
}

resource "aws_ecs_service" "newrelic" {
  name = "newrelic-infra"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.newrelic_infra_task_definition.arn
  scheduling_strategy = "DAEMON"
  launch_type = "EC2"
}
