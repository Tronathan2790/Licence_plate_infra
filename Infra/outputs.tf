output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "sqs_queue_url" {
  value = aws_sqs_queue.licence_plate_queue.id
}

output "keda_sqs_role_arn" {
  value = aws_iam_role.keda_sqs_role.arn
}