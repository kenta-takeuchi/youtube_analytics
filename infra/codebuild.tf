data "aws_iam_policy_document" "codebuild" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
  }
}

resource "aws_codebuild_project" "this" {
  name         = "youtube-movies-analytics"
  service_role = module.codebuild_role.iam_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "youtube-movies-analytics/account:AWS_ACCOUNT_ID"
      type  = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "AWS_ACCESS_KEY_ID"
      value = "youtube-movies-analytics/account:AWS_ACCESS_KEY_ID"
      type  = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "AWS_SECRET_ACCESS_KEY"
      value = "youtube-movies-analytics/account:AWS_SECRET_ACCESS_KEY"
      type  = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "AWS_REGION"
      value = "ap-northeast-1"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}

module "codebuild_role" {
  source     = "./iam_role"
  name       = "codebuild"
  identifier = "codebuild.amazonaws.com"
  policy     = data.aws_iam_policy_document.codebuild.json
}