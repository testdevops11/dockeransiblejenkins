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
            post {
            always {
                jiraSendBuildInfo site: 'testing-devops123.atlassian.net'
                }
            }
        }
        
        
        stage('Maven Build'){
            steps{
                sh "mvn clean package"
            }
        }
        stage('Sonarqube') {
                environment {
                scannerHome = tool 'SonarQubeScanner'
                }
                steps {
                    withSonarQubeEnv('sonarqube') {
                    sh "${scannerHome}/bin/sonar-scanner" -Dsonar.projectKey=develop -Dsonar.sources=. "
                    }
                    timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                    }
                }
        }
        
        stage('Docker Build'){
            steps{
                sh " docker build . -t sahilthakre123/sampleapp:${DOCKER_TAG} "
            }
        }
        stage('Docker push dockerhub'){
            steps{
                withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHUBPwd')]) {
                    sh "docker login -u sahilthakre123 -p ${dockerHubPwd}"
                }
                sh "docker push sahilthakre123/sampleapp:${DOCKER_TAG}"
            }
        }
        stage('Ansible deployement to slaves'){
            steps{
                ansiblePlaybook become: true, credentialsId: 'ssh-12', disableHostKeyChecking: true, extras: '-e DOCKER_TAG=$DOCKER_TAG', installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
            }
        }
    }
}

 

def getVersion(){
    def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}
