# Modernizing Infra Tooling
This [Terragrunt](https://terragrunt.gruntwork.io/) project is responsible for deploying infra behind the Modernizing Tooling blog. No [Terraform](https://www.terraform.io/) code lives in this project; rather all Terraform modules are versioned separately in their own GitHub repos.

## Local setup
Please run the following to install pre-commit hooks and tools:
```bash
brew install pre-commit shellcheck sops
pre-commit install # from local module repo
```

All commits to this repo are now subject to linting according to our pre-commit hooks.
