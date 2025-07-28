# https://github.com/kubernetes-sigs/aws-ebs-csi-driver

resource "kubernetes_storage_class" "gp3_encrypted" {
  count = var.enable_gp3_storage_class ? 1 : 0
  metadata {
    name = "gp3-kms"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  parameters = {
    type      = "gp3",
    encrypted = true
    kmsKeyId  = var.kms_key_arn
  }
  volume_binding_mode = "WaitForFirstConsumer"
}
