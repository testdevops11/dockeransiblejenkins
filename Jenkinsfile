pipeline{
    agent any
    tools {
      maven 'maven3'
    }
    environment {
      DOCKER_TAG = getVersion()
    }
    stages{
        stage('SCM'){
            steps{
               git 'https://github.com/testdevops11/dockeransiblejenkins.git'
            }
        }
        
        stage('Maven Build'){
            steps{
                sh "mvn clean package"
            }
            post {
                 always {
                    jiraSendBuildInfo branch: '', site: 'testing-devops123.atlassian.net'
                 }
            }
        }
        
        
        stage('Docker Build'){
            steps{
                sh " docker build . -t sahilthakre123/sampleapp:${DOCKER_TAG} "
            }
        }
        stage('DockerHub Push'){
            steps{
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]) {
                    sh "docker login -u sahilthakre123 -p ${dockerHubPwd}"
                }
                
                sh "docker push sahilthakre123/sampleapp:${DOCKER_TAG} "
            }
        }
        stage('Docker deploy using ansible'){
            steps{
                ansiblePlaybook become: true, credentialsId: 'dev-server', disableHostKeyChecking: true, extras: "-e DOCKER_TAG=${DOCKER_TAG}", installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
            }
        }
    }
}

def getVersion(){
    def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
