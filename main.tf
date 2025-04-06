resource "aws_eks_cluster" "whiskerwag_eks_cluster" {
    name = "whiskerwag_eks_cluster"
    role_arn = aws_iam_role.whiskerwag_eks_cluster_role.arn
    vpc_config {
      subnet_ids = data.aws_subnets.default1.ids
    }

    depends_on = [ aws_iam_role_policy_attachment.whiskerwag_AmazonEKSClusterPolicy ]
}

resource "aws_eks_fargate_profile" "whiskerwag_eks_fargate_profile" {
    fargate_profile_name = "whiskerwag_eks_fargate_profile"
    pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
    cluster_name = aws_eks_cluster.whiskerwag_eks_cluster.name
    subnet_ids = ["aws_subnet.private_subnet_1.id","aws_subnet.private_subnet_2.id"]
    selector {
      namespace = "default"
    }

    depends_on = [ aws_iam_role.fargate_pod_execution_role ]
}