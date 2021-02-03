output "K8s-cluster-role-arn" {
  value = aws_iam_role.cluster.arn
}

output "kubeconfig" {
  value = local.kubeconfig
}
