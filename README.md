# AWS Cloud Resume Challenge

My implementation of the [Cloud Resume Challenge](https://cloudresumechallenge.dev/docs/the-challenge/aws/) — a multi-step project that demonstrates core cloud skills by deploying a resume as a full-stack serverless application on AWS.

## Architecture

Browser → CloudFront → S3 (static site) → JavaScript → Lambda Function URL → DynamoDB (visitor counter)

Infrastructure is managed with Terraform. Frontend deploys automatically via GitHub Actions on push to `main`.

<img src="https://github.com/MiguelAngelHorta/AWS-Cloud-Resume/assets/106134627/d4e938e6-765a-448c-8d93-c11d4524bd76" alt="Architecture diagram" width="700">

## Project Structure

```
├── website/                  # Frontend (deployed to S3)
│   ├── index.html
│   ├── style.css
│   ├── visitorCounter.js
│   └── profile.jpg
├── infra/                    # Terraform infrastructure
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── lambda/
│       └── func.py
└── .github/workflows/
    └── front-end-cicd.yaml   # CI/CD pipeline
```

## Services Used

- **S3** — Static website hosting
- **CloudFront** — CDN and HTTPS
- **Certificate Manager** — SSL/TLS certificate
- **Lambda** — Visitor counter API
- **DynamoDB** — Persistent view count storage
- **GitHub Actions** — Automated deployment
- **Terraform** — Infrastructure as Code

## Setup

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 1.5
- An S3 bucket for the website
- A DynamoDB table named `MH-resume` with partition key `id` (String)

### Deploy Infrastructure
```bash
cd infra
terraform init
terraform plan
terraform apply
```

### Configure GitHub Actions
Add these secrets to your repo (Settings → Secrets → Actions):
- `AWS_S3_BUCKET` — Your S3 bucket name
- `AWS_ACCESS_KEY_ID` — IAM access key with S3 write permissions
- `AWS_SECRET_ACCESS_KEY` — Corresponding secret key

Pushes to `main` that modify files in `website/` will automatically sync to S3.

## Live Site

[resume.miguelhorta.com](https://www.resume.miguelhorta.com)
