# General vars

variable "aws_region" {
  description = "Region To Use For the resources"
  default     = "us-west-2"
}

variable "aws_account" {
  description = "AWS Account Number"
  default     = ""
}

variable "aws_profile" {
  default = "default"
}

variable "tf_state_bucket" {
  description = "string used to base various names on"
  default     = "pact-terraform"
}

variable "tf_state_lock_database" {
  description = "Terraform state lock Database Name"
  default     = "Terraform_State_Lock"
}

variable "aws_eks_oidc" {
  description = "aws_eks_cluster.eks.endpoint"
  default     = "https://1FD93B8E64436F22A87E0E2D53B9E6D9.gr7.us-west-2.eks.amazonaws.com"
}

#----------------------------------------------------------------------------------
# EKS Cluser Variables
#----------------------------------------------------------------------------------

variable "aws_k8s_cluster" {
  description = "Name of the K8s Cluster."
  type        = string
  default     = "PACT-K8s"
}

variable "worker_node_key" {
  default = "achaudhari-pact-ec2-key"
}

variable "cluster_encryption_enabled" {
  type        = bool
  default     = true
  description = "Set to `true` to enable Cluster Encryption Configuration"
}

variable "aws_k8s-version" {
  description = "Version Of The Cluster and Worker Nodes"
  type        = string
  default     = "1.18"
}

variable "aws_k8s_cw_logging" {
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  type        = list
  description = "Enable EKS CWL for EKS components"
}

variable "cluster_encryption_config_resources" {
  type        = list
  default     = ["secrets"]
  description = "Cluster Encryption Config Resources to encrypt, e.g. ['secrets']"
}

variable "cluster_encryption_config_enabled" {
  type        = bool
  default     = true
  description = "Set to `true` to enable Cluster Encryption Configuration"
}

variable "endpoint_private_access" {
  type        = bool
  default     = false
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false"
}

variable "endpoint_public_access" {
  type        = bool
  default     = true
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is true"
}

variable "public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0."
}

#----------------------------------------------------------------------------------
# EKS Worker Nodes Variables
#----------------------------------------------------------------------------------
variable "desired-capacity" {
  default     = 1
  type        = string
  description = "Autoscaling Desired node capacity"
}

variable "max-size" {
  default     = 5
  type        = string
  description = "Autoscaling maximum node capacity"
}

variable "min-size" {
  default     = 1
  type        = string
  description = "Autoscaling Minimum node capacity"
}

variable "aws_subnet_name" {
  default     = "Sutantra-Subnet-Pub"
  type        = string
  description = "Subnet name"
}

variable "aws-node-instance-type" {
  default     = "t2.micro"
  type        = string
  description = "EKS Worker Node Instance Type"
}

variable "ec2_ssh_key" {
  type        = string
  description = "SSH key name that should be used to access the worker nodes"
  default     = "achaudhari-pact-ec2-key"
}

variable "source_security_group_ids" {
  type        = string
  description = "Worker node security group ID's"
  default     = "all-internal-sg"
}

variable "ami_release_version" {
  type        = string
  description = "AMI version of the EKS Node Group. Defaults to latest version for Kubernetes version"
  default     = "1.18.9-20201126"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version. Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided"
  default     = "1.18"
}

variable "force_update_version" {
  type        = bool
  description = "Force version update if existing pods are unable to be drained due to a pod disruption budget issue."
  default     = true
}

variable "ami_type" {
  type        = string
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values: `AL2_x86_64`, `AL2_x86_64_GPU`. Terraform will only perform drift detection if a configuration value is provided"
  default     = "AL2_x86_64"
}

#----------------------------------------------------------------------------------
# VPC Variables
#----------------------------------------------------------------------------------
variable "aws_vpc_id" {
  description = "VPC ID for EKS Cluster To Be Created"
  type        = string
}

#----------------------------------------------------------------------------------
# KMS Variables
#----------------------------------------------------------------------------------
variable "enable_key_rotation" {
  type        = bool
  default     = true
  description = "Specifies whether key rotation is enabled"
}

variable "key_usage" {
  default     = "ENCRYPT_DECRYPT"
  description = "Key usage is whether for Encryption Decryption Or For Signing"
}

variable "customer_master_key_spec" {
  default     = "SYMMETRIC_DEFAULT"
  description = "Which type of the key is this Symmetric Or Assymetric"
}

variable "kms_enabled" {
  type        = bool
  default     = true
  description = "key is enabled"
}

#----------------------------------------------------------------------------------
# TAGS Variables
#----------------------------------------------------------------------------------
variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default = {
    "organization" = "PACT Pharma"
    "project"      = "Microservices Migration To K8s"
    "client"       = "Internal"
    "user"         = "Kubernetes"
  }
}
