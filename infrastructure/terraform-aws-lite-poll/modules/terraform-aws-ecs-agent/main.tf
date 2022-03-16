data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com", "ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "get_parameters" {
  statement {
    actions = ["ssm:GetParameters"]
    effect = "Allow"
    resources = [var.license_key_arn]
  }
}

resource "aws_iam_policy" "get_parameters_policy" {
  name = "test_policy"
  policy = data.aws_iam_policy_document.get_parameters.json
}

resource "aws_iam_role" "ecs_agent" {
  name = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "get_parameters" {
  role = aws_iam_role.ecs_agent.name
  policy_arn = aws_iam_policy.get_parameters_policy.arn
}

resource "aws_iam_role_policy_attachment" "logs_agent" {
  role = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSIoTLogging"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}
