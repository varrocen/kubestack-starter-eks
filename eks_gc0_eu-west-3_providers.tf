provider "aws" {
  alias = "eks_gc0_eu-west-3"

  region = "eu-west-3"
}

provider "kustomization" {
  alias = "eks_gc0_eu-west-3"

  kubeconfig_raw = module.eks_gc0_eu-west-3.kubeconfig
}

locals {
  eks_gc0_eu-west-3_kubeconfig = yamldecode(module.eks_gc0_eu-west-3.kubeconfig)
}

provider "kubernetes" {
  alias = "eks_gc0_eu-west-3"

  host                   = local.eks_gc0_eu-west-3_kubeconfig["clusters"][0]["cluster"]["server"]
  cluster_ca_certificate = base64decode(local.eks_gc0_eu-west-3_kubeconfig["clusters"][0]["cluster"]["certificate-authority-data"])
  token                  = local.eks_gc0_eu-west-3_kubeconfig["users"][0]["user"]["token"]
}
