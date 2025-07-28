resource "aws_security_group" "this" {
  name        = local.security_group_name
  description = "Security group for bastion host - managed via AWS Systems Manager"
  vpc_id      = var.vpc_id

  egress {
    description = "HTTPS outbound for package updates and AWS API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP outbound for package updates"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.this.id]
  subnet_id                   = element(var.private_subnets, 0)
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  user_data = templatefile("${path.module}/scripts/setup.sh", {
    region       = data.aws_region.current.name
    cluster_name = var.cluster_name
  })
  user_data_replace_on_change = true

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    encrypted             = true
    kms_key_id            = data.aws_ebs_default_kms_key.current.key_arn
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  lifecycle {
    ignore_changes = [ami]
  }
}
