# Kubestack starter EKS demo

Install the CLI: https://www.kubestack.com/framework/tutorial/

## Initialize repository with AWS

Base configuration:
* base_domain: sdx-vincent-arrocena.aws.wescale.fr
* name_prefix: gc0 (General Compute)
* Region: eu-west-3 (Paris)

```bash
# kbst init eks <base-domain> <name-prefix> <region>
kbst init eks sdx-vincent-arrocena.aws.wescale.fr gc0 eu-west-3
```

## Provision Infrastructure

Run in bootstrap container:

```bash
# Build the bootstrap container
docker build -t kbst-infra-automation:bootstrap .

# Exec into the bootstrap container
docker run --rm -ti \
    -v `pwd`:/infra \
    kbst-infra-automation:bootstrap
```

Setup authentication: https://www.kubestack.com/framework/tutorial/provision-infrastructure/

```bash
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

## Follow the GitOps process

Create branch:

```bash
 git add .
 git commit -m "Add Github Actions pipeline"
 git push origin ghactions
```

Open a pull request and merge.

```bash
# checkout the main branch
git checkout main
# pull changes from origin
git pull
# tag the merge commit
git tag apps-deploy-0
# push the tag to origin to trigger the pipeline
git push origin apps-deploy-0
```

## Nginx Ingress Installation

Add nginx service:

```bash
# add nginx service to every cluster
# append --cluster-name NAME
# to only add to a single cluster
kbst add service nginx
```

Manualy apply:

```bash
terraform apply --target module.eks_gc0_eu-west-1_service_nginx
```

Add DNS zone ressource:

```hcl
module "eks_gc0_eu-west-3_dns_zone" {
  providers = {
    aws        = aws.eks_gc0_eu-west-3
    kubernetes = kubernetes.eks_gc0_eu-west-3
  }

  # make sure to match your cluster module's version
  source = "github.com/kbst/terraform-kubestack//aws/cluster/elb-dns?ref=v0.19.2-beta.0"

  ingress_service_name      = "ingress-nginx-controller"
  ingress_service_namespace = "ingress-nginx"

  metadata_fqdn = module.eks_gc0_eu-west-3.current_metadata["fqdn"]
}
```

Apply changes:

```bash
# create a new feature branch
git checkout -b add-nginx-ingress

# add the changes and commit them
git add .
git commit -m "Install nginx ingress, cloud loadbalancer and DNS"

# push the changes to trigger the pipeline
git push origin add-nginx-ingress
```

Promote changes:

```bash
# make sure you're on the merge commit
git checkout main
git pull

# then tag the commit 
git tag apps-deploy-$(git rev-parse --short HEAD)

# finally push the tag, to trigger the pipeline to promote
git push origin apps-deploy-$(git rev-parse --short HEAD)
```

## Get kubeconfig

```bash
aws eks update-kubeconfig --region eu-west-3 --name gc0-ops-eu-west-3
aws eks update-kubeconfig --region eu-west-3 --name gc0-apps-eu-west-3
```
