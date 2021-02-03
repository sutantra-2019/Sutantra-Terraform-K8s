locals {
  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority.0.data}
  name: ${var.aws_k8s_cluster}
contexts:
- context:
    cluster: ${var.aws_k8s_cluster}
    user: ${var.aws_k8s_cluster}
  name: ${var.aws_k8s_cluster}
current-context: ${var.aws_k8s_cluster}
kind: Config
preferences: {}
users:
- name: ${var.aws_k8s_cluster}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${var.aws_k8s_cluster}"
        - "--region"
        - "${var.aws_region}"
KUBECONFIG
}
