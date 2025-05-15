
# Hexite ZenXAI AWS Infrastructure

This repository contains Terraform configurations for provisioning AWS infrastructure to support the Hexite ZenXAI project in the `dev` environment.

## 🔧 Components Deployed

The infrastructure provisions the following key AWS resources:

### 1. **EC2 Instance**
- Launches an EC2 instance using a specified AMI and instance type.
- Integrated with Application Load Balancer (ALB).
- Connected to RDS and ElastiCache via Security Groups.

### 2. **Amazon RDS**
- Provisions a PostgreSQL-compatible RDS database instance.
- Supports customizable DB name, user, password, and instance type.
- Publicly accessible with CIDR whitelist (use caution with `0.0.0.0/0`).

### 3. **Amazon ElastiCache (Redis)**
- Deploys a Redis node using `cache.t4g.small` instance type.
- Configured to allow access from the EC2 security group.

### 4. **Application Load Balancer (ALB)**
- ALB is created with:
  - HTTP listener on port 80
  - Security group allowing inbound HTTP traffic
  - Target group with health checks
  - Targets the deployed EC2 instance

---

## 📁 Directory Structure

```text
.
├── envs/
│   └── dev/
│       ├── main.tf          # Composes infrastructure from modules
│       ├── variables.tf     # Environment-specific variables
│       ├── outputs.tf       # Environment outputs
│       └── backend.tf       # (Optional) Remote backend configuration
├── modules/
│   ├── alb/                 # ALB configuration module
│   ├── ec2/                 # EC2 configuration module
│   ├── rds/                 # RDS configuration module
│   └── redis/               # ElastiCache (Redis) configuration module
```

---

## 🚀 Getting Started

### Prerequisites

- Terraform CLI v1.0 or later
- AWS CLI configured with sufficient IAM permissions
- An existing AWS key pair (e.g., `zenxai-key-dev`)

### Initialization

```bash
cd envs/dev
terraform init
```

### Plan Infrastructure

```bash
terraform plan
```

### Apply Infrastructure

```bash
terraform apply
```

---

## 🔐 Required Input Variables

Defined in `variables.tf`:

- `aws_region` – AWS region (default: `ap-south-1`)
- `project_id` – Project identifier (default: `zenxai`)
- `env` – Deployment environment (default: `dev`)
- `rds_name` – RDS database name
- `rds_user` – RDS username
- `rds_password` – RDS password
- `rds_instance_class` – e.g., `db.t3.medium`

---

## 📤 Outputs

Defined in `outputs.tf`:

- `rds_db_endpoint` – Endpoint of the provisioned RDS instance
- `alb_dns_name` – DNS of the ALB
- `alb_sg_id` – ALB security group ID

---

## 📄 License

This project is licensed under the MIT License. See `LICENSE` file for details.

---

## 🧩 Notes

- The current setup is intended for development environments.
- For production, ensure better CIDR restrictions and secure secret handling using tools like AWS Secrets Manager or SSM.
