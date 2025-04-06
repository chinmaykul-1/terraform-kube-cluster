pipeline{
    
        agent "any"
    
    environment{
        AWS_REGION = 'ap-south-1'
        CLUSTER_NAME = 'whiskerwag_eks_cluster'
        KUBECONFIG = "${WORKSPACE}/kubeconfig"
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
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
                sh '''
                 ansible-playbook deploy-pods.yml -e kubeconfig=$KUBECONFIG
                '''
                }
            }
        }
    }

}


