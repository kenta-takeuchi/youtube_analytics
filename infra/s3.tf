resource "aws_s3_bucket" "frontend" {
  bucket = "${local.product_name}-frontend"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.frontend.json
}


data "aws_iam_policy_document" "frontend" {
  statement {
    effect = "Allow"
    sid    = "PublicReadGetObject"
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]
    resources = ["arn:aws:s3:::${aws_s3_bucket.frontend.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}



resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-practice-docker-terraform"

  lifecycle_rule {
    enabled = true
    expiration {
      days = "7"
    }
  }
}

resource "aws_s3_bucket" "artifact" {
  bucket = "artifact-practice-docker-terraform"

  lifecycle_rule {
    enabled = true
    expiration {
      days = "7"
    }
  }
}


resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["582318560864"]
    }
  }
}