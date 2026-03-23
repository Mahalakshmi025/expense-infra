resource "aws_key_pair" "eks" {
  key_name   = "eks"
  #public_key = file("~/.ssh/eks.pub")
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCShEcAG+QxcOHLCy/IP8WsK/OzJTv41hcNypN9C5GpyM45iQ/7BILtrj7KSRmCyR8vhFkOg+DXv8X2LF22iOoGCXB+F9Jy5v0Zq1Twb1GXooPA78Ux9EqbHhQCAm5TjAHovsMk1i2EnZ9YSRX0owHMOCzKtuZud9lIfVnjlAzUEOq819tVNtEHk+udgouNUMGtXhbYsOIrCzlpBTXvHJiBoxI2p7r6ycW8gHrumnwYtQxkGrbVa2HUsN/PhuAqmPQgKy6m3MvY7Xg7nFoVtg7Cc9v0NE70MqU4L9rQkrLVekMUQg+ehytFwhlS1nDt86KLaWY0wcbQJsxTQp8ijDIn5RcL8VJi9Bsojc+aGI26eqe0VTwfZrcqeG+wRKJHCPZnrUpqPpqwYzlC9WSYc2ABHLORwvtOuL/8yDWR9pwxtV9W9l6ei2eAPhijwmcDQeAKQpAuWUEROP82LJZG4SoW+ztrjf0pmneaoQKxK5DxoL8Lv0EVJ0S03Wx5D0YkRM3zCJv4FsFKVVTMUE6Dx39WetsWT2XSILqh4f76daGT7DVKdt9zOgk8o+zFCLviX6IZ4yCm2gKvyN2DfUP2rLg/lpvHjXyjKJgWowJ/ZVpmZONziRSZyZfZjO+oxely74AypTGk2ZQQbviwlcZjHLusISkzGqoDpkcR+J95VhAdTw== srima@Maha"

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.project_name}-${var.environment}"
  kubernetes_version = "1.32"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = data.aws_ssm_parameter.vpc_id.value
  subnet_ids               = local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  create_security_group = false
 security_group_id     = local.eks_control_plane_sg_id

  create_node_security_group = false
  node_security_group_id     = local.node_sg_id

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    # blue = {
    #   # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
    #   ami_type       = "AL2023_x86_64_STANDARD"
    #   instance_types = ["m5.xlarge"]
    #     iam_role_additional_policies = {
    #       AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    #       AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    #       AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    #       AmazonEBSCSIDriverPolicy           = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    #       AmazonElasticFileSystemFullAccess  = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
    #       ElasticLoadBalancingFullAccess     = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
    #     }
 
    #   min_size     = 2
    #   max_size     = 10
    #   desired_size = 2
    # }

       green = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]
        iam_role_additional_policies = {
          AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
          AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
          AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
          AmazonEBSCSIDriverPolicy           = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
          AmazonElasticFileSystemFullAccess  = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
          ElasticLoadBalancingFullAccess     = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
        }
 
      min_size     = 2
      max_size     = 10
      desired_size = 2
    }
  }

  tags = var.common_tags
}
# resource "aws_key_pair" "eks" {
#   key_name   = "eks"
#   # you can paste the public key directly like this
#   #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6ONJth+DzeXbU3oGATxjVmoRjPepdl7sBuPzzQT2Nc sivak@BOOK-I6CR3LQ85Q"
#   public_key = file("~/.ssh/eks.pub")
#   # ~ means windows home directory
# }

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"


#   cluster_name    = "${var.project_name}-${var.environment}"
#   cluster_version = "1.32"

#   cluster_endpoint_public_access  = true

#   cluster_addons = {
#     coredns                = {}
#     eks-pod-identity-agent = {}
#     kube-proxy             = {}
#     vpc-cni                = {}
#   }

#   vpc_id                   = data.aws_ssm_parameter.vpc_id.value
#   subnet_ids               = local.private_subnet_ids
#   control_plane_subnet_ids = local.private_subnet_ids

#   create_cluster_security_group = false
#   cluster_security_group_id     = local.eks_control_plane_sg_id

#   create_node_security_group = false
#   node_security_group_id     = local.node_sg_id

#   # the user which you used to create cluster will get admin access

#   # EKS Managed Node Group(s)
#   eks_managed_node_group_defaults = {
#     instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
#   }

#   eks_managed_node_groups = {
#     # blue = {
#     #   min_size      = 2
#     #   max_size      = 10
#     #   desired_size  = 2
#     #   #capacity_type = "SPOT"
#     #   iam_role_additional_policies = {
#     #     AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
#     #     AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
#     #     ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
#     #   }
#     #   # EKS takes AWS Linux 2 as it's OS to the nodes
#     #   key_name = aws_key_pair.eks.key_name
#     # }
#     green = {
#       min_size      = 2
#       max_size      = 10
#       desired_size  = 2
#       #capacity_type = "SPOT"
#       iam_role_additional_policies = {
#         AmazonEBSCSIDriverPolicy          = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
#         AmazonElasticFileSystemFullAccess = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
#         ElasticLoadBalancingFullAccess = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
#       }
#       # EKS takes AWS Linux 2 as it's OS to the nodes
#       key_name = aws_key_pair.eks.key_name
#     }
#   }

#   # Cluster access entry
#   # To add the current caller identity as an administrator
#   enable_cluster_creator_admin_permissions = true

#   tags = var.common_tags
# }