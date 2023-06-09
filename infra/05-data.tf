data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name
}
