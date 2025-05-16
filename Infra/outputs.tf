output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "sqs_queue_url" {
  value = aws_sqs_queue.licence_plate_queue.url
}

output "keda_sqs_role_arn" {
  value = aws_iam_role.keda_sqs_role.arn
}

output "oidc_provider_url" {
  value = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}