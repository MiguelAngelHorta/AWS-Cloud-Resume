# AWS Cloud Resume

My cloud resume built as a full-stack serverless application on AWS, inspired by the [Cloud Resume Challenge](https://cloudresumechallenge.dev/docs/the-challenge/aws/).

Live at [miguelhorta.com](https://miguelhorta.com)

## Architecture
Browser → Route 53 (DNS) → CloudFront (CDN + SSL via ACM)
→ S3 (static site: HTML, CSS, JS)
→ Lambda Function URL (Python) → DynamoDB (visitor counter)

Infrastructure managed with Terraform. Frontend auto-deploys via GitHub Actions on push to `main`.

<img src="https://github.com/MiguelAngelHorta/AWS-Cloud-Resume/assets/106134627/d4e938e6-765a-448c-8d93-c11d4524bd76" alt="Architecture diagram" width="700">

## Project Structure
├── website/                   # Frontend (deployed to S3)
│   ├── index.html
│   ├── style.css
│   ├── visitorCounter.js
│   └── profile.jpg
├── infra/                     # Terraform IaC
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── lambda/
│       └── func.py            # Python visitor counter
└── .github/workflows/
└── front-end-cicd.yaml    # CI/CD pipeline

## AWS Services

| Service | Purpose |
|---------|---------|
| **S3** | Static website hosting |
| **CloudFront** | CDN and HTTPS |
| **Route 53** | DNS routing |
| **ACM** | SSL/TLS certificates |
| **Lambda** | Python visitor counter API |
| **DynamoDB** | Persistent view count storage |
| **Terraform** | Infrastructure as Code |
| **GitHub Actions** | CI/CD auto-deploy to S3 |

## Setup

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 1.5
- S3 bucket for the website
- DynamoDB table named `MH-resume` with partition key `id` (String)

### Deploy Infrastructure
```bash
cd infra
terraform init
terraform plan
terraform apply
```

### Configure GitHub Actions
Add these secrets in your repo (Settings → Secrets → Actions):
- `AWS_S3_BUCKET` — S3 bucket name
- `AWS_ACCESS_KEY_ID` — IAM access key with S3 write permissions
- `AWS_SECRET_ACCESS_KEY` — Corresponding secret key

Pushes to `main` that modify files in `website/` will automatically sync to S3.

## Live Site

[miguelhorta.com](https://miguelhorta.com)
