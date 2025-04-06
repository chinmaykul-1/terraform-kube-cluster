resource "aws_iam_role" "whiskerwag_eks_cluster_role" {
    name = "whiskerwag_eks_cluster_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement=[{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "eks.amazonaws.com"
            } 
        }]
    })
  
}


resource "aws_iam_role_policy_attachment" "whiskerwag_AmazonEKSClusterPolicy" {
    role = aws_iam_role.whiskerwag_eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  
}


resource "aws_iam_role" "fargate_pod_execution_role" {
    name = "fargate_pod_execution_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "eks-fargate-pods.amazonaws.com"
        }
    }]
    })
}

resource "aws_iam_role_policy_attachment" "whiskerwag_AmazonEKSFargatePolicy" {
  role = aws_iam_role.fargate_pod_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}