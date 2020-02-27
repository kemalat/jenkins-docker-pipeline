def DOCKER_HUB_USER="kemalat"
def HTTP_PORT="8080"

pipeline {

  environment {
    registry = "kemalat/sbootdocker"
    registryCredential = 'dockerhub'
    PATH = "/usr/local/bin:$PATH"
  }

  stages {

    stage('Checkout') {
        checkout scm
        sh 'git checkout master'
        sh 'printenv'
    }
    stage('Unit Test'){

      PATH = "/usr/local/bin:${env.PATH}"

      sh 'docker-compose -f docker-compose-test-and-package.yml up --abort-on-container-exit'
      sh 'docker-compose -f docker-compose-test-and-package.yml down -v'
      sh 'docker rmi -f sbootdocker-test'
    }
  }

}
