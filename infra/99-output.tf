output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "s3_report_bucket" {
  description = "Bucket for reporting"
  value       = aws_s3_bucket.s3_report_bucket.id
}

output "iam_role_report" {
  description = "IAM Role for reporting"
  value       = aws_iam_role.bucket_role.arn
}