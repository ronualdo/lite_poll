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

resource "aws_launch_configuration" "ecs_launch_config" {
  name_prefix="lite-poll"
  image_id = data.aws_ami.default.id
  iam_instance_profile = var.iam_instance_profile_name
  security_groups = [aws_security_group.ecs_security_group.id]
  user_data = "#!/bin/bash\necho ECS_CLUSTER=lite-poll-cluster >> /etc/ecs/ecs.config"
  instance_type = "t2.micro"
  associate_public_ip_address = true
}

resource "aws_autoscaling_group" "default" {
  desired_capacity = 1
  health_check_type = "EC2"
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  max_size = 2
  min_size = 1
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

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
  name = "asg"
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity = 2
  min_size = 1
  max_size = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  vpc_zone_identifier = var.subnets_ids
}

resource "aws_ecs_cluster" "cluster" {
  name = "lite-poll-cluster"
}

data "template_file" "task_definition_template" {
  template = file("modules/terraform-aws-service/task_definition.json.tpl")
  vars = {
    REPOSITORY_URL = replace(var.image_repo_url, "https://", "")
    DB_HOST = var.db_host,
    DB_USER = var.db_user,
    DB_PASSWORD = var.db_password,
    DB_PORT = var.db_port
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "worker"
  container_definitions = data.template_file.task_definition_template.rendered
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
