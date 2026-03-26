# Terraform AWS Infrastructure

Infrastructure as Code (IaC) configuration for deploying and managing AWS resources using Terraform.

## Overview

This Terraform project automates the provisioning of AWS EC2 instances and related infrastructure components. It follows best practices for modular, reusable, and maintainable infrastructure code.

## Project Structure

```
terraform/
├── data.tf              # Data sources definitions
├── launch-instance.tf   # EC2 instance configuration
├── locals.tf            # Local variable definitions
├── outputs.tf           # Output values
├── variables.tf         # Input variables
├── terraform.tfstate    # State file (managed by Terraform)
├── terraform.tfstate.backup  # State backup
├── .terraform.lock.hcl  # Dependency lock file
├── .gitignore           # Git ignore rules
├── space.sh             # Utility shell script
└── readme.md            # This file
```

## Prerequisites

- **Terraform** >= 1.0 (install from [terraform.io](https://www.terraform.io/downloads))
- **AWS CLI** configured with valid credentials
- **AWS Account** with appropriate IAM permissions
- **Git** for version control

## Setup Instructions

### 1. Initialize Terraform

```bash
terraform init
```

This command initializes the Terraform working directory and downloads required providers.

### 2. Validate Configuration

```bash
terraform validate
```

Verify that your configuration is syntactically valid.

### 3. Plan Infrastructure Changes

```bash
terraform plan -out=tfplan
```

Review planned changes before applying them.

### 4. Apply Configuration

```bash
terraform apply tfplan
```

Deploy the infrastructure to AWS.

### 5. Destroy Infrastructure (when needed)

```bash
terraform destroy
```

Remove all managed resources.

## Configuration Files

### variables.tf

Defines input variables for the infrastructure. Customize these values before deployment.

### locals.tf

Defines local variables used throughout the configuration for consistency and reusability.

### data.tf

Data sources for querying existing AWS resources (e.g., AMI IDs, availability zones).

### launch-instance.tf

Main configuration file for EC2 instance provisioning with associated resources.

### outputs.tf

Output values that display important information after infrastructure deployment (e.g., instance IDs, IP addresses).

## AWS Resources Managed

This configuration typically manages:

- EC2 Instances
- Security Groups
- VPC/Network configurations
- IAM Roles and Policies
- Storage volumes

## Usage Examples

### Deploy Single Environment

```bash
terraform plan
terraform apply
```

### Deploy with Variable Overrides

```bash
terraform apply -var="instance_type=t3.medium" -var="instance_count=2"
```

### View Outputs

```bash
terraform output
terraform output instance_ids
```

### Refresh State

```bash
terraform refresh
```

## State Management

- **State Files:** `terraform.tfstate` and `terraform.tfstate.backup` store infrastructure state
- **Remote State:** Consider using S3/DynamoDB for team environments
- **State Locking:** Enable state locking to prevent concurrent modifications

### Enable Remote State (Recommended)

Create a `backend.tf` file:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "docker/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

## Best Practices

✓ **Version Control:** Commit `.tf` files but exclude state files
✓ **State Management:** Use remote backends for team collaboration
✓ **Variable Organization:** Use `.tfvars` files for environment-specific values
✓ **Lock Files:** Commit `.terraform.lock.hcl` for dependency consistency
✓ **Code Review:** Use `terraform plan` output for change reviews
✓ **Naming Conventions:** Use descriptive names for resources
✓ **Documentation:** Keep this README updated with infrastructure changes
✓ **Monitoring:** Use AWS CloudWatch and CloudTrail for resource monitoring

## Common Commands Reference

| Command                           | Purpose                      |
| --------------------------------- | ---------------------------- |
| `terraform init`                  | Initialize working directory |
| `terraform validate`              | Check syntax                 |
| `terraform plan`                  | Preview changes              |
| `terraform apply`                 | Deploy infrastructure        |
| `terraform destroy`               | Remove infrastructure        |
| `terraform refresh`               | Update state file            |
| `terraform output`                | Display outputs              |
| `terraform state list`            | List resources in state      |
| `terraform state show <resource>` | Show resource details        |
| `terraform fmt`                   | Format configuration files   |

## Troubleshooting

### State Lock Issues

```bash
terraform force-unlock <LOCK_ID>
```

### Provider/Plugin Issues

```bash
terraform init -upgrade
rm -rf .terraform
terraform init
```

### State Sync Problems

```bash
terraform refresh
terraform plan
```

## Security Considerations

- Never commit sensitive data (passwords, API keys) to Git
- Use AWS Secrets Manager or Parameter Store for sensitive values
- Enable state file encryption
- Implement IAM policies with least privilege principle
- Use VPC security groups to restrict access
- Regularly audit infrastructure changes

## Contributing

1. Create a feature branch for changes
2. Run `terraform fmt` to format code
3. Run `terraform validate` to check syntax
4. Test with `terraform plan` before merging
5. Update this README if infrastructure changes
6. Submit pull request for review

## Support & Documentation

- [Terraform Official Docs](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices)

## License

[Add your license here]

---

**Last Updated:** March 26, 2026
**Maintained By:** [Your Team/Name]
**Status:** Active
