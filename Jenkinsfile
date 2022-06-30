pipeline {
    agent any 
    environment {
        registryCredential = 'dockerhubcredential'
        imageName = 'deepakdinio/devops-bootcamp-internal'
        dockerImage = ''
        }
    stages {
        stage('Run the tests') {
             agent {
                docker { 
                    image 'node:18-alpine'
                    args '-e HOME=/tmp -e NPM_CONFIG_PREFIX=/tmp/.npm'
                    reuseNode true
                }
            }
            steps {
                echo 'Retrieve source from github' 
                git branch: 'master',
                    url: 'https://github.com/deepakdinio/Git_DevOps_Internal.git'

                echo 'showing files from repo?' 
                sh 'ls -a'
                echo 'install dependencies' 
                sh 'npm install'
                echo 'Run tests'
                sh 'npm test'
                echo 'Testing completed'
            }
        }
        stage('Building image') {
            steps{
                script {
                    echo 'building image' 
                    dockerImage = docker.build("${env.imageName}:${env.BUILD_ID}")
                    echo 'image built'
                }
            }
            }
        stage('Push Image') {
            steps{
                script {
                    echo 'pushing the image to docker hub' 
                    docker.withRegistry('',registryCredential){
                        dockerImage.push("${env.BUILD_ID}")
                    }
                }
            }
        }     
         stage('deploy to k8s') {
             agent {
                docker { 
                    image 'google/cloud-sdk:latest'
                    args '-e HOME=/tmp'
                    reuseNode true
                        }
                    }
            steps {
                echo 'Get cluster credentials'
                sh 'gcloud container clusters get-credentials cluster-1 --zone us-central1-c --project roidtc-june22-u104'
                sh "kubectl set image deployment/internal-deployment internal=${env.imageName}:${env.BUILD_ID} --namespace=demo"

             }
        }     
        stage('Remove local docker image') {
            steps{
                echo "pending"

                sh "docker rmi ${env.imageName}:${env.BUILD_ID}"
            }
        }
    }
}