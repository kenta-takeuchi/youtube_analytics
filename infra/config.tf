terraform {
  backend "s3" {
    bucket = "tfstate-youtube-movies-analytics-terraform"
    key    = "terraform.state"
    region = "ap-northeast-1"
  }
}