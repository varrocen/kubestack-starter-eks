module "eks_gc0_eu-west-3_service_nginx" {
  providers = {
    kustomization = kustomization.eks_gc0_eu-west-3
  }

  source  = "kbst.xyz/catalog/nginx/kustomization"
  version = "1.10.1-kbst.0"

  configuration = {
    apps = {}
    ops  = {}
  }
}

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
