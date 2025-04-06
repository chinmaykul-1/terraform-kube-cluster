pipeline{

        agent "any"
    
    environment{
        AWS_REGION = 'ap-south-1'
        CLUSTER_NAME = 'whiskerwag_eks_cluster'
        KUBECONFIG = "/root/.jenkins/workspace/terraform-eks-cluster/kubeconfig"
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages{
        stage("Deploy Infra - Create IAM roles"){
            steps{
                withCredentials([
    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
]){
                sh '''
                        terraform init
                        terraform apply -target=aws_iam_role.whiskerwag_eks_cluster_role -auto-approve
                        terraform apply -target=aws_iam_role.fargate_pod_execution_role -auto-approve
                    '''
            }
            }
        }
        stage("Deploy Infra - Create EKS cluster"){
            steps{
                withCredentials([
    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
]){
                sh '''
                terraform init
                terraform apply -target=aws_eks_cluster.whiskerwag_eks_cluster -auto-approve
                '''
            }
            }
        }
        stage("Deploy Infra - Create private subnets"){
            steps{
                withCredentials([
    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
]){
                sh '''
                terraform init
                terraform apply -target=aws_subnet.private_subnet_2 -target aws_subnet.private_subnet_1 -target aws_route_table.private_rt -target aws_route_table_association.private_association_1 -target aws_route_table_association.private_association_2 -auto-approve
                '''
            }
            }
        }
          stage("Deploy Infra -EKS- fargate profile"){
            steps{
                withCredentials([
    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
]){
                sh '''
                terraform init
                terraform apply -target=aws_eks_fargate_profile.whiskerwag_eks_fargate_profile -auto-approve
                '''
            }
            }
        }
         stage("Set kubeconfig"){
            steps{
                sh '''
                aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME --kubeconfig $KUBECONFIG
                '''
            }
        }
        stage("Deploy Pods Using ansible"){
            steps{
                dir('ansible'){
                    withCredentials([
    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
]){
                sh '''
                export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                export AWS_DEFAULT_REGION=ap-south-1
                 ansible-playbook deploy-app.yml -e kubeconfig=$KUBECONFIG
                '''
                }
                
            }
            }
        }
    }

}


