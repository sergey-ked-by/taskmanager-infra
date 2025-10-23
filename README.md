# Task Manager Infrastructure

This repository contains the infrastructure as code (IaC) for the Task Manager application, managed using Terragrunt and Terraform.

## Project Structure

The project is organized into the following main directories:

- `terragrunt/envs/`: Contains environment-specific configurations (e.g., `azure-testing`). Each subdirectory within an environment represents a specific service or component (e.g., `acr`, `aks`, `db`, `vnet`).
- `terragrunt/modules/`: Contains reusable Terraform modules that define the infrastructure components (e.g., `azure-acr`, `azure-aks`, `azure-db-postgres`, `azure-vnet`).

## Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (for Azure authentication)

### Validation

To validate the Terragrunt and Terraform configurations, navigate to the `terragrunt/envs/azure-testing` directory and run:

```bash
terragrunt validate --all
```

This command will recursively run `terraform validate` for all `terragrunt.hcl` files found in the subdirectories.

### Deployment

(Instructions for deployment will be added here)

## Modules Overview

- **`azure-acr`**: Azure Container Registry module.
- **`azure-aks`**: Azure Kubernetes Service module.
- **`azure-db-postgres`**: Azure PostgreSQL Database module.
- **`azure-vnet`**: Azure Virtual Network module.
