provider "github" {
  token        = local.github_token
  organization = local.github_owner
}

resource "github_repository_webhook" "this" {
  events     = ["push"]
  repository = local.github_repository

  configuration {
    url          = aws_codepipeline_webhook.this.url
    secret       = local.github_secret_key
    content_type = "json"
    insecure_ssl = false
  }
}