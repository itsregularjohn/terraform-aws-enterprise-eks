# Enterprise EKS Reference Architecture on AWS with Terraform

[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-support%20my%20work-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://coff.ee/itsregularjohn)

This repository encapsulates over 5 years of experience managing high load Kubernetes EKS environment on AWS.

A production-ready, enterprise-grade Kubernetes setup built on AWS using Terraform. This repository demonstrates complete multi-account AWS architecture patterns with EKS, following security best practices and operational excellence principles.

Architecture decisions are based on personal experience and recommendations from [Jack Lindamood's "Every infrastructure decision I endorse or regret after 4 years running infrastructure at a startup"](https://cep.dev/posts/every-infrastructure-decision-i-endorse-or-regret-after-4-years-running-infrastructure-at-a-startup/), with detailed rationale documented in [Architecture Decision Records](./docs/architecture/decisions/) (being populated retroactively).

## Architecture Overview

This repository demonstrates a mature enterprise multi-account AWS architecture organized using AWS Organizational Units (OUs) following AWS best practices for security, scalability, and operational efficiency. The architecture implements foundational, application, and experimental OUs to minimize blast radius and adhere to least privilege principles.

### Account Hierarchy Diagram

```
Org Root
├── Management
│   └── SSO, Organizations, Billing
├── Security OU (Foundational)
│   ├── Logs (CloudTrail, Config)
│   └── Security Tooling (GuardDuty, Security Hub)
├── Infrastructure OU (Foundational)
│   ├── Networking (Transit Gateway, VPCs)
│   ├── Services (CI/CD, Shared Tools)
│   ├── Monitoring (CloudWatch, Grafana)
│   └── Backup (AWS Backup, DR)
├── Workloads OU (Application)
│   ├── Development (Dev Environments)
│   ├── Staging (Pre-prod Testing)
│   └── Production (EKS, Live Workloads)
└── Sandbox OU (Experimental)
    └── Sandbox (PoCs, Learning)
```

## Multi-Account Strategy

The infrastructure uses [AWS Organizations](https://aws.amazon.com/organizations/) to manage multiple accounts organized into Organizational Units (OUs) as guided by the [Organizing Your AWS Environment Using Multiple Accounts AWS Whitepaper](https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/organizing-your-aws-environment.html)

### Organizational Unit Structure

Management Account

| Account    | Purpose                                | Key Components                                                     |
| ---------- | -------------------------------------- | ------------------------------------------------------------------ |
| Management | Organization root, billing, governance | AWS Organizations, SSO (IAM Identity Center), Consolidated Billing |

Security OU (Foundational)

| Account          | Purpose                                   | Key Components                                                   |
| ---------------- | ----------------------------------------- | ---------------------------------------------------------------- |
| Logs             | Centralized logging and compliance        | S3 buckets (immutable), CloudTrail (org-wide), Config Aggregator |
| Security Tooling | Security monitoring and incident response | Security Hub, GuardDuty, IAM roles for break-glass access        |

Infrastructure OU (Foundational)

| Account    | Purpose                                  | Key Components                                                |
| ---------- | ---------------------------------------- | ------------------------------------------------------------- |
| Networking | Shared network infrastructure            | Transit Gateway, shared VPCs, Route53 DNS, Network Firewall   |
| Services   | Shared tools and utilities               | CI/CD pipelines, internal wikis, licensing, shared services   |
| Monitoring | Centralized monitoring and observability | CloudWatch dashboards, Grafana, alerting, metrics aggregation |
| Backup     | Centralized backup and disaster recovery | AWS Backup, cross-account backup policies, DR orchestration   |

Workloads OU (Application)

| Account     | Purpose                   | Key Components                                                 |
| ----------- | ------------------------- | -------------------------------------------------------------- |
| Development | Application development   | Development environments, feature testing, integration testing |
| Staging     | Pre-production testing    | Production-like environment for final validation               |
| Production  | Live production workloads | EKS clusters, microservices, container workloads               |

Sandbox OU (Experimental)

| Account | Purpose                      | Key Components                                                   |
| ------- | ---------------------------- | ---------------------------------------------------------------- |
| Sandbox | Experimentation and learning | Developer playground, proof-of-concepts, short-lived experiments |

### Account Structure

```
accounts/
├── management/          # Organization root (AWS Organizations, SSO)
│   └── global/
│       ├── 01-aws-sso/
│       └── 02-organizations/
├── ...
└── production/
    └── us-east-1/      # Primary region
        ├── 01-networking/  # Modules organized by sequence
        ├── 02-eks-cluster/
        ├── 03-bastion-host/
        └── 04-elasticache/
```

## Modules

### Root Modules (Account Implementations)

- [AWS Organizations](./accounts/management/global/02-organizations/) - Multi-account setup and governance
- [SSO & IAM Identity Center](./accounts/management/global/01-aws-sso/) - Centralized authentication
- [VPC Networking](./accounts/production/us-east-1/01-networking/) - Multi-AZ VPC optimized for EKS
- [EKS Cluster](./accounts/production/us-east-1/02-eks-cluster/) - Production-ready Kubernetes with auto-scaling
- [Bastion Host](./accounts/production/us-east-1/03-bastion-host/) - Secure cluster access via AWS Systems Manager
- [ElastiCache](./accounts/production/us-east-1/04-elasticache/) - Redis clustering for application caching

### Reusable Modules (Infrastructure Components)

The `/modules/aws/` directory contains reusable, well-documented modules that follow [Google Terraform Best Practices](https://cloud.google.com/docs/terraform/best-practices/general-style-structure) and are scanned with [Trivy](https://github.com/aquasecurity/trivy/) for [AquaSec misconfigurations](https://avd.aquasec.com/misconfig/aws/):

#### Core Infrastructure
- [Networking](./modules/aws/networking/) - Production-ready VPC with multi-AZ subnets, NAT gateways, and EKS integration
- [EKS](./modules/aws/eks/) - Enterprise Kubernetes cluster with security hardening
- [Bastion](./modules/aws/bastion/) - Secure SSM-based bastion host with comprehensive audit logging
- [ElastiCache](./modules/aws/elasticache/) - Redis cluster with encryption and monitoring

#### Security & Compliance
- [CloudTrail](./modules/aws/cloudtrail/) - Organization-wide audit logging with KMS encryption
- [Billing Alarms](./modules/aws/billing-alarms/) - Cost management and budget monitoring

#### Kubernetes Add-ons
- [EKS Add-ons](./modules/aws/eks-addons/) - Essential Kubernetes components:
  - AWS Load Balancer Controller
  - Cluster Autoscaler  
  - EBS CSI Driver
  - VPC CNI
  - CoreDNS
  - Metrics Server
  - Cert Manager
  - External Secrets Operator
  - Ingress NGINX
  - Datadog Integration
  - Redis Operator

#### Monitoring & Observability
- [EKS Monitoring](./modules/aws/eks-monitoring/) - Complete monitoring stack:
  - Prometheus & Grafana
  - Loki for log aggregation
  - Blackbox Exporter
  - Service Monitors
  - Alert Manager

#### Network Extensions
- [Site-to-Site VPN](./modules/aws/site-to-site-vpn/) - Hybrid cloud connectivity

Each module includes comprehensive documentation, input/output specifications, security features, cost considerations, and compliance information. See individual module READMEs for detailed usage examples and configuration options.

## Security Features

- Encryption at Rest: All storage volumes encrypted with customer-managed KMS keys
- Encryption in Transit: TLS/SSL for all network communication
- Access Control: Least-privilege IAM roles and policies
- Audit Logging: Complete API call logging via CloudTrail
- Monitoring: CloudWatch integration for metrics and alerting
- Security Scanning: Trivy integration for AquaSec misconfiguration detection
- Zero Trust: SSM-based access eliminating SSH key management

## Security & Compliance Standards

This repository implements security best practices from multiple frameworks:

- [AquaSec Misconfigurations](https://avd.aquasec.com/misconfig/aws/) - Scanned with Trivy for AWS security misconfigurations
- [Google Terraform Best Practices](https://cloud.google.com/docs/terraform/best-practices/general-style-structure) - Code structure and organization standards
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) - Security, reliability, and operational excellence pillars
- CIS Benchmarks - Industry-standard security configurations
- SOC 2 Compliance - Audit logging and access control capabilities

*Note: Security scanning and best practices implementation is ongoing and not fully complete across all modules.*

## Quick Start

### Prerequisites

Before getting started, make sure you have:

- AWS CLI installed and configured
- OpenTofu v1.6.x installed (tested version)
- An AWS profile configured in your `~/.aws/credentials` file

## 🛠 Setup Customization

⚠️ IMPORTANT: AWS Account Limits

AWS Organizations has a default limit of 4 accounts per organization (including the management account). This means you can initially create only 3 additional member accounts.

If you try to create more accounts, you'll get:
```
ConstraintViolationException: You have exceeded the allowed number of AWS accounts.
```

Solution: Request a quota increase through [AWS Service Quotas](https://console.aws.amazon.com/servicequotas/) before deploying additional accounts. Search for "Organizations" → "Default maximum number of accounts" → Request increase to 15-20 accounts.

This repository includes feature flags to control which accounts are created, allowing you to start with a minimal setup and expand gradually:

- Minimal setup (3 accounts): Management + Production + Sandbox
- Essential setup (6 accounts): Add Logs + Development + Security Tooling  
- Complete setup (11 accounts): Full enterprise multi-account architecture

See [`accounts/management/global/02-organizations/README.md`](./accounts/management/global/02-organizations/README.md) for detailed account planning.

Before deploying, replace all placeholder values:

- `profile = "terraform-showcase"` → your AWS CLI profile name
- `bucket = "jp-terraform-showcase-terraform"` → your S3 bucket name
- Replace `admin@example.com` and `Admin User` with your email and name

This repository uses `terraform-showcase` as the default AWS profile name and `jp-terraform-showcase-terraform` as the default S3 bucket name for Terraform state. You'll need to either create matching profiles/buckets or replace these values throughout the codebase.

### Deployment Steps

1. Clone the repository

  ```bash
  git clone git@github.com:itsregularjohn/aws-kubernetes-terraform-enterprise-showcase.git
  cd aws-kubernetes-terraform-enterprise-showcase
  ```

2. Create S3 bucket for Terraform state (if not exists)

   ```bash
   # Create the S3 bucket for state management (replace bucket name as needed)
   aws s3 mb s3://jp-terraform-showcase-terraform --profile terraform-showcase --region us-east-1

   # Enable versioning for state history
   aws s3api put-bucket-versioning --profile terraform-showcase \
     --bucket jp-terraform-showcase-terraform \
     --versioning-configuration Status=Enabled

   # Enable server-side encryption
   aws s3api put-bucket-encryption --profile terraform-showcase \
     --bucket jp-terraform-showcase-terraform \
     --server-side-encryption-configuration '{
       "Rules": [{
         "ApplyServerSideEncryptionByDefault": {
           "SSEAlgorithm": "AES256"
         }
       }]
     }'

   # Block public access
   aws s3api put-public-access-block --profile terraform-showcase \
     --bucket jp-terraform-showcase-terraform \
     --public-access-block-configuration \
     "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
   ```

3. Set up AWS SSO and Multi-Account Foundation

   ```bash
   cd accounts/management/global/02-organizations
   terraform init
   terraform plan
   terraform apply

   cd ../01-aws-sso
   terraform init
   terraform plan
   terraform apply

   # Configure SSO user and CLI access (see management/README.md)
   ```

4. Deploy Production VPC

   ```bash
   cd accounts/production/us-east-1/01-networking
   terraform init
   terraform plan
   terraform apply
   ```

5. Deploy EKS cluster

   ```bash
   cd ../02-eks-cluster
   terraform init
   terraform plan
   terraform apply
   ```

6. Access your Kubernetes cluster

   ```bash
   # Configure AWS CLI with SSO (first time setup)
   aws configure sso
   # Follow prompts to set up SSO profile for production account
   # SSO start URL: https://[your-identity-store-id].awsapps.com/start
   # SSO Region: us-east-1
   # Account: [000000000000]
   # Role: EKSClusterAdmin (for full cluster access) or EKSDeveloper (for app deployment)
   # CLI profile name: production-eks-admin

   # Login to SSO session
   aws sso login --profile production-eks-admin

   # Update kubeconfig using SSO profile
   aws eks update-kubeconfig --region us-east-1 --name production --profile production-eks-admin

   # Verify cluster access
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

   Note: The EKS cluster is deployed in the production account, so you need to use AWS SSO to assume the appropriate role (`EKSClusterAdmin` or `EKSDeveloper`) in the production account for cluster access.

## Contributing

This repository showcases enterprise infrastructure patterns. For questions or suggestions, please open an issue.

## 🏷️ Attribution

If you use this project as a reference, build upon it, or incorporate any substantial portions into your work, please provide attribution:

Original Author: João Pedro Alves de Oliveira  
Repository: https://github.com/itsregularjohn/terraform-aws-enterprise-eks

See [`LICENSE`](./LICENSE) and [`NOTICE`](./NOTICE) for complete terms.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Built by João Pedro Alves - Demonstrating enterprise Kubernetes infrastructure patterns on AWS