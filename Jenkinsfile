pipeline {
    agent {
        docker {
            image 'maven:3-alpine' 
            args '-v /root/.m2:/root/.m2' 
        }
    }
    stages {
    
        stage('Clone repository') {
            /* Let's make sure we have the repository cloned to our workspace */
            steps {
                checkout scm
            }
        }

        stage('Build') { 
            steps {
                sh 'mvn -B package' 
            }
        }

        stage('Build image') {
            /* This builds the actual image; synonymous to
             * docker build on the command line */
            steps{
                script {
                    app = docker.build("devops/hello")
                }    
            }
        }

        stage('Test image') {
            /* Ideally, we would run a test framework against our image.
             * For this example, we're using a Volkswagen-type approach ;-) */
             steps{
                script {
                    app.inside {
                        sh 'echo "Tests passed"'
                    }
                }    
              }       
        }

        stage('Push image') {
            /* Finally, we'll push the image with two tags:
             * First, the incremental build number from Jenkins
             * Second, the 'latest' tag.
             * Pushing multiple tags is cheap, as all the layers are reused. */
                steps{
                    withCredentials([usernamePassword( credentialsId: '97423d7a-052d-4eb0-ae4b-fd759ad37d8e', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        script {
                            docker.withRegistry('','97423d7a-052d-4eb0-ae4b-fd759ad37d8e') {
                                sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                                app.push("${env.BUILD_NUMBER}")
                                app.push("latest")
                            }
                        }
                    }   
                }
        }
    }     
}
