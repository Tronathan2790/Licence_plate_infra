module "eks"  {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "Licence_Plate_Cluster"
  cluster_version = "1.31"
  
  enable_irsa = true
  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
  vpc_id                   = aws_vpc.main.id
  subnet_ids               = [aws_subnet.Subnet_1.id,aws_subnet.Subnet_2.id,aws_subnet.Subnet_3.id]
  control_plane_subnet_ids = [aws_subnet.Subnet_1.id,aws_subnet.Subnet_2.id,aws_subnet.Subnet_3.id]
  access_entries = {
    # One access entry with a policy associated
    example = {
      principal_arn = "arn:aws:iam::346337206895:user/Github"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        }
      }
    }
  }
 
  eks_managed_node_groups = {
    Licence_Plate_Cluster = {
    
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 1
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

data "aws_eks_cluster" "this" {
  name = "Licence_Plate_Cluster"  
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}



