# EKS Pod Identity Agent
# https://docs.aws.amazon.com/eks/latest/userguide/pod-id-agent-setup.html
# https://github.com/aws/eks-pod-identity-agent
# https://www.eksworkshop.com/docs/security/amazon-eks-pod-identity/use-pod-identity
# https://aws.amazon.com/blogs/containers/amazon-eks-pod-identity-a-new-way-for-applications-on-eks-to-obtain-iam-credentials/
# Helm chart: https://github.com/aws/eks-pod-identity-agent/tree/main/charts/eks-pod-identity-agent
# Chart README: https://raw.githubusercontent.com/aws/eks-pod-identity-agent/refs/heads/main/charts/eks-pod-identity-agent/README.md

# TODO: Implement EKS Pod Identity Agent
# Note: This agent typically uses node-level permissions rather than IRSA
# Required environment variables: EKS_CLUSTER_NAME, AWS_REGION_NAME

resource "helm_release" "eks_pod_identity_agent" {
  count = var.enable_eks_pod_identity_agent ? 1 : 0

  chart     = "eks-pod-identity-agent"
  namespace = "kube-system"
  name      = "eks-pod-identity-agent"
  # repository = "TBD" # Chart location needs to be determined
  # version    = "TBD" # Version needs to be determined

  # TODO: Add required configuration
  # - EKS_CLUSTER_NAME environment variable
  # - AWS_REGION_NAME environment variable
  # - Determine if IRSA is needed or uses node permissions
  # - Configure image repository and tag
}
