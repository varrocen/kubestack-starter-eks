module "eks_gc0_eu-west-3_service_cert-manager" {
  providers = {
    kustomization = kustomization.eks_gc0_eu-west-3
  }

  source  = "kbst.xyz/catalog/cert-manager/kustomization"
  version = "1.15.1-kbst.0"

  configuration = {
  apps = {
    additional_resources = ["${path.root}/manifests/cluster-issuer.yaml"]
  }
  ops = {
    patches = [
      {
        patch = <<-EOF
          - op: replace
            path: /spec/acme/server
            value: https://acme-staging-v02.api.letsencrypt.org/directory
        EOF
          
        target = {
          group   = "cert-manager.io"
          version = "v1"
          kind    = "ClusterIssuer"
          name    = "letsencrypt"
        }
      }
    ]
  }
  }
}
