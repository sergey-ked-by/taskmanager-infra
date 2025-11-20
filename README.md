# Task Manager Infrastructure

This repository contains the Infrastructure as Code (IaC) for the Task Manager application, managed using Terragrunt and Terraform. It is responsible for defining and deploying all necessary cloud resources on Microsoft Azure.

## Project Ecosystem

This repository is a core component of a multi-repo project:

1.  **`taskmanager-app`**: The core Spring Boot application. It triggers the deployment process in this repository.
2.  **`taskmanager-tests-java`**: Contains the test suite. This repository triggers smoke tests after a successful deployment.
3.  **`taskmanager-infra`** (This repository): The deployment engine. It uses Terragrunt and Terraform to provision and manage the infrastructure on Azure.

## Automated Deployment (CI/CD)

This repository acts as the deployment engine for the entire project, orchestrated by the GitHub Actions workflow defined in `.github/workflows/infra.yml`.

### Deployment Trigger

The workflow is **not** typically run directly. Instead, it is triggered by a `repository_dispatch` event from the `taskmanager-app` repository. This happens automatically whenever a new version of the application is built after a merge to the `main` branch.

### Deployment Process

1.  **Event Received**: The workflow starts when it receives the `deploy-staging` event. The event payload contains the `image_tag` for the new Docker image of the application.
2.  **Set Terraform Variable**: The workflow extracts the `image_tag` and sets it as an environment variable named `TF_VAR_app_image_tag`. Terragrunt automatically passes variables in this format to the underlying Terraform modules.
3.  **Apply Infrastructure**: The workflow runs `terragrunt run-all apply`. Terragrunt then orchestrates Terraform to apply any necessary changes to the cloud infrastructure. This includes updating the Azure Kubernetes Service (AKS) deployment to use the new application image tag.
4.  **Trigger Smoke Tests**: After `terragrunt apply` completes successfully, the workflow sends a `repository_dispatch` event (`run-smoke-suite`) to the `taskmanager-tests-java` repository. This tells the test repository to run a quick suite of smoke tests against the newly updated staging environment to verify its health.

## Manual Deployment

While the primary method of deployment is automated, you can still run Terragrunt manually.

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.8.5+
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/) v0.58.10+
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (and be logged in)
- Correct Azure credentials configured as environment variables (`ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, etc.).

### Commands

To apply all infrastructure changes for the `azure-testing` environment manually:

1.  Navigate to the environment directory:
    ```bash
    cd terragrunt/envs/azure-testing
    ```
2.  Set the application image tag you wish to deploy. This is required by the Terraform scripts.
    ```bash
    export TF_VAR_app_image_tag="your-image-tag-here"
    ```
3.  Run the apply command:
    ```bash
    terragrunt run-all apply
    ```

To validate the configuration without applying changes, you can run `terragrunt run-all validate`.