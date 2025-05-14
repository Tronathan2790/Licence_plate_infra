module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.31"

  
  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
  vpc_id                   = aws_vpc.main.id
  subnet_ids               = [aws_subnet.Subnet_1.id,aws_subnet.Subnet_2.id,aws_subnet.Subnet_3.id]
  control_plane_subnet_ids = [aws_subnet.Subnet_1.id,aws_subnet.Subnet_2.id,aws_subnet.Subnet_3.id]

 
  eks_managed_node_groups = {
    example = {
    
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