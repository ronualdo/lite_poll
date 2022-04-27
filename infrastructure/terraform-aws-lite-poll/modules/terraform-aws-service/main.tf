# iam
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

# end iam

resource "aws_launch_configuration" "ecs_launch_config" {
  image_id = "ami-00ee4df451840fa9d"
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = var.security_group_ids
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=my-cluster >> /etc/ecs/ecs.config"
  instance_type        = "t2.micro"
}

resource "aws_autoscaling_group" "default" {
  desired_capacity     = 1
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  max_size             = 2
  min_size             = 1
  name                 = "auto-scaling-group"

  tag {
    key                 = "Env"
    propagate_at_launch = true
    value               = "production"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "blog"
  }

  target_group_arns    = var.scaling_group_arns
  termination_policies = ["OldestInstance"]

  vpc_zone_identifier = var.vpc_zone_identifiers
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
  name = "asg"
  vpc_zone_identifier = var.vpc_zone_identifiers
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity = 2
  min_size = 1
  max_size = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
}

# move repository
resource "aws_ecr_repository" "image_repo" {
  name = "lite-poll-image-repo"
}

resource "aws_ecs_cluster" "cluster" {
  name = "lite-poll-cluster"
}

data "template_file" "task_definition_template" {
  template = file("modules/terraform-aws-service/task_definition.json.tpl")
  vars = {
    REPOSITORY_URL = replace(aws_ecr_repository.image_repo.repository_url, "https://", "")
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
    container_port = 8080
  }
}
