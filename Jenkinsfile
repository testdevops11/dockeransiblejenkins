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
               git 'https://github.com/SambaGoggula/dockeransiblejenkins.git'
            }
        }
         stage('Maven Build'){
            steps{
                sh "mvn clean package"
            }
            post {
                 always {
                   jiraSendBuildInfo branch: '', site: 'testingdevopssamba.atlassian.net'
                 }
            }
        }
         stage('Docker Build'){
            steps{
                sh " docker build . -t samba1295/sampleapp:${DOCKER_TAG} "
            }
        }
        stage('DockerHub Push'){
            steps{
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]) {
                    sh "docker login -u samba1295 -p ${dockerHubPwd}"
                }
                
                sh "docker push samba1295/sampleapp:${DOCKER_TAG} "
            }
        }
        stage('Docker deploy using ansible'){
            steps{
                ansiblePlaybook become: true, credentialsId: 'dev-server2', disableHostKeyChecking: true, extras:"-e DOCKER_TAG=${DOCKER_TAG}", installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
            }
        }
    }
}
def getVersion(){
    def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
