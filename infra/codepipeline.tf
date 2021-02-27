resource "aws_codepipeline" "this" {
  name     = local.product_name
  role_arn = module.codepipeline_role.iam_role_arn

  artifact_store {
    location = aws_s3_bucket.artifact.id
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name     = "Source"
      category = "Source"
      owner    = "ThirdParty"
      provider = "GitHub"
      version  = 1
      output_artifacts = [
      "Source"]

      configuration = {
        OAuthToken           = local.github_token
        Owner                = local.github_owner
        Repo                 = local.github_repository
        Branch               = "main"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"
    action {
      name     = "Build"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = 1
      input_artifacts = [
      "Source"]
      output_artifacts = [
        "Frontend",
      "Backend"]

      configuration = {
        ProjectName = aws_codebuild_project.this.id
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name     = "DeployFrontend"
      category = "Deploy"
      owner    = "AWS"
      provider = "S3"
      version  = 1
      input_artifacts = [
      "Frontend"]

      configuration = {
        BucketName = aws_s3_bucket.frontend.id
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name     = "DeployBackend"
      category = "Deploy"
      owner    = "AWS"
      provider = "ECS"
      version  = 1
      input_artifacts = [
      "Backend"]

      configuration = {
        ClusterName = aws_ecs_cluster.this.name
        ServiceName = aws_ecs_service.this.name
        FileName    = "imagedefinitions.json"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "this" {
  authentication  = "GITHUB_HMAC"
  name            = local.product_name
  target_action   = "Source"
  target_pipeline = aws_codepipeline.this.name

  authentication_configuration {
    secret_token = local.github_secret_key
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }

}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect = "Allow"
    resources = [
    "*"]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "iam:PassRole",
    ]
  }
}

module "codepipeline_role" {
  source     = "./iam_role"
  name       = "codepipeline"
  identifier = "codepipeline.amazonaws.com"
  policy     = data.aws_iam_policy_document.codepipeline.json
}