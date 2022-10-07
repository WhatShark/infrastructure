variable "portfolio-github-access-token" {
  type = string
  sensitive = true
}

resource "aws_amplify_app" "portfolio" {
  name       = "portfolio"
  repository = "https://github.com/WhatShark/portfolio"
  access_token = var.portfolio-github-access-token

  build_spec = <<-EOT
    version: 1
    frontend:
        phases:
            preBuild:
                commands:
                    - npm ci
            build:
                commands:
                    -   npm run build
        artifacts:
            baseDirectory: build
            files:
                - '**/*'
        cache:
            paths:
            - node_modules/**/*
  EOT

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }
}

resource "aws_amplify_branch" "portfolio-main" {
  app_id      = aws_amplify_app.portfolio.id
  branch_name = "main"
  enable_auto_build = true

  framework = "React"
  stage     = "PRODUCTION"
}