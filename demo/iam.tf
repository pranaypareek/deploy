# This is the ECS policy required so that agent has access to ECS service
resource "aws_iam_policy" "trriplejayECSPolicy" {
  name = "trriplejayECSPolicy"
  description = "ECS Policy for trriplejay"
  path = "/"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": "ecs:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        }
    ]
}
EOF
}

# AWS role for ECS
resource "aws_iam_role" "trriplejayECSRole" {
  name = "trriplejayECSRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attaching the role to the policy
resource "aws_iam_policy_attachment" "trriplejayRolePolicyAttach" {
  name = "trriplejayRolePolicyAttach"
  roles = [
    "${aws_iam_role.trriplejayECSRole.name}"]
  policy_arn = "${aws_iam_policy.trriplejayECSPolicy.arn}"
}

# creating an instance profile so that container instances have right role
resource "aws_iam_instance_profile" "trriplejayECSInstProf" {
  name = "trriplejayECSInstProf"
  roles = [
    "${aws_iam_role.trriplejayECSRole.name}"]
}
