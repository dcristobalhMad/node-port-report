locals {
  cluster_name = "diego-eks-assessment"
  oidc_part              = replace(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, "https://", "")
}