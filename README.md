# Kubestack starter EKS demo

Install the CLI: https://www.kubestack.com/framework/tutorial/

## Initialize repository with AWS

Base configuration:
* base_domain: sdx-vincent-arrocena.aws.wescale.fr
* name_prefix: gc0 (General Compute)
* Region: eu-west-3 (Paris)

```
# kbst init eks <base-domain> <name-prefix> <region>
kbst init eks sdx-vincent-arrocena.aws.wescale.fr gc0 eu-west-3
```

## Provision Infrastructure

Run in bootstrap container:

```
# Build the bootstrap container
docker build -t kbst-infra-automation:bootstrap .

# Exec into the bootstrap container
docker run --rm -ti \
    -v `pwd`:/infra \
    kbst-infra-automation:bootstrap
```

Setup authentication: https://www.kubestack.com/framework/tutorial/provision-infrastructure/

```
# Initialize Terraform
terraform init

# Create apps and ops workspaces
terraform workspace new apps
terraform workspace new ops

# Bootstrap the ops environment
terraform workspace select ops
terraform apply --auto-approve

# Bootstrap the apps environment
terraform workspace select apps
terraform apply --auto-approve
```
