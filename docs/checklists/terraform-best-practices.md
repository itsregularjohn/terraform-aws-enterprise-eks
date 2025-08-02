# Terraform Best Practices Checklist

Based on [Terraform on Google Cloud Best Practices](https://cloud.google.com/docs/terraform/best-practices/general-style-structure) adapted to AWS environment.

## General Style and Structure

| Item | Description                                    | Status | Notes |
| ---- | ---------------------------------------------- | ------ | ----- |
| 1.1  | Follow a standard module structure             | 🟩     |       |
| 1.2  | Adopt a naming convention                      | 🟩     |       |
| 1.3  | Use variables carefully                        | 🟩     |       |
| 1.4  | Expose outputs                                 | 🟩     |       |
| 1.5  | Use data sources                               | 🟩     |       |
| 1.6  | Limit the use of custom scripts                | 🟩     |       |
| 1.7  | Include helper scripts in a separate directory | 🟩     |       |
| 1.8  | Put static files in a separate directory       | 🟩     |       |
| 1.9  | Protect stateful resources                     | 🟩     |       |
| 1.10 | Use built-in formatting                        | 🟩     |       |
| 1.11 | Limit the complexity of expressions            | 🟩     |       |
| 1.12 | Use count for conditional values               | 🟩     |       |
| 1.13 | Use for_each for iterated resources            | 🟩     |       |
| 1.14 | Publish modules to a registry                  | ⏳     |       |

## Reusable Modules

| Item | Description                             | Status | Notes |
| ---- | --------------------------------------- | ------ | ----- |
| 2.1  | Activate required APIs in modules       | ⏳     |       |
| 2.2  | Include an owners file                  | ⏳     |       |
| 2.3  | Release tagged versions                 | ⏳     |       |
| 2.4  | Don't configure providers or backends   | 🟩     |       |
| 2.5  | Expose labels as a variable             | 🔄     |       |
| 2.6  | Expose outputs for all resources        | 🔄     |       |
| 2.7  | Use inline submodules for complex logic | 🔄     |       |

## Root Modules

| Item | Description                                                 | Status | Notes                   |
| ---- | ----------------------------------------------------------- | ------ | ----------------------- |
| 3.1  | Minimize the number of resources in each root module        | 🔄     |                         |
| 3.2  | Use separate directories for each application               | 🟩     |                         |
| 3.3  | Split applications into environment-specific subdirectories | ⏳     |                         |
| 3.4  | Use environment directories                                 | 🟧     | accounts-based setup    |
| 3.5  | Expose outputs through remote state                         | 🟩     |                         |
| 3.6  | Pin to minor provider versions                              | 🟩     |                         |
| 3.7  | Store variables in a tfvars file                            | 🟧     | Root modules use locals |
| 3.8  | Check in .terraform.lock.hcl file                           | 🟩     |                         |

## Dependency Management

| Item | Description                                            | Status | Notes |
| ---- | ------------------------------------------------------ | ------ | ----- |
| 4.1  | Favor implicit dependencies over explicit dependencies | 🔄     |       |
| 4.2  | Reference output attributes from dependent resources   | 🔄     |       |

## Cross-Configuration Communication

| Item | Description                                                 | Status | Notes     |
| ---- | ----------------------------------------------------------- | ------ | --------- |
| 5.1  | Use remote state to reference other root modules            | 🟩     |           |
| 5.2  | Use Cloud Storage or Terraform Enterprise as state backends | 🟩     | Amazon S3 |

## Working with Google Cloud Resources

| Item | Description                           | Status | Notes   |
| ---- | ------------------------------------- | ------ | ------- |
| 6.1  | Bake virtual machine images           | ⏳     |         |
| 6.2  | Manage Identity and Access Management | 🟩     | AWS IAM |

## Version Control

| Item | Description                                      | Status | Notes |
| ---- | ------------------------------------------------ | ------ | ----- |
| 7.1  | Use a default branching strategy                 | ⏳     |       |
| 7.2  | Use environment branches for root configurations | ⏳     |       |
| 7.3  | Allow broad visibility                           | ⏳     |       |
| 7.4  | Never commit secrets                             | 🟩     |       |
| 7.5  | Organize repositories based on team boundaries   | ⏳     |       |

## Operations

| Item | Description                                                | Status | Notes                        |
| ---- | ---------------------------------------------------------- | ------ | ---------------------------- |
| 8.1  | Always plan first                                          | 🟩     |                              |
| 8.2  | Implement an automated pipeline                            | ⏳     |                              |
| 8.3  | Use service account credentials for continuous integration | ⏳     |                              |
| 8.4  | Avoid importing existing resources                         | ❌     |                              |
| 8.5  | Don't modify Terraform state manually                      | 🟩     |                              |
| 8.6  | Regularly review version pins                              | ⏳     |                              |
| 8.7  | Use application default credentials when running locally   | ❌     | Always use named credentials |
| 8.8  | Set aliases to Terraform                                   | 🟩     |                              |
| 8.9  | Use remote state                                           | 🟩     |                              |

## Security

| Item | Description                  | Status | Notes |
| ---- | ---------------------------- | ------ | ----- |
| 9.1  | Never commit secrets         | 🟩     |       |
| 9.2  | Encrypt state                | 🟩     |       |
| 9.3  | Don't store secrets in state | ⏳     |       |
| 9.4  | Mark sensitive outputs       | ⏳     |       |
| 9.5  | Ensure separation of duties  | ⏳     |       |
| 9.6  | Run pre-apply checks         | ⏳     |       |
| 9.7  | Run continuous audits        | ⏳     |       |

## Testing

| Item | Description                              | Status | Notes |
| ---- | ---------------------------------------- | ------ | ----- |
| 10.1 | Use less expensive test methods first    | ⏳     |       |
| 10.2 | Start small                              | ⏳     |       |
| 10.3 | Randomize project IDs and resource names | ⏳     |       |
| 10.4 | Use a separate environment for testing   | ⏳     |       |
| 10.5 | Clean up all resources                   | ⏳     |       |
| 10.6 | Optimize test runtime                    | ⏳     |       |

---

**Legend:**

- 🟩 Implemented
- ❌ Not Implemented / Won't Implement
- ⏳ To Be Reviewed
- 🔄 In Progress
