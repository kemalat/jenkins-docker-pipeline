# jenkins-pipeline-build-dockerize-run
Review of Jenkins file which prepares packages, run tests, perform docker builds  and runs docker images

A continuous delivery (CD) pipeline is an automated process for getting software from version control and building the 
software through multiple stages of testing and deployment. Jenkins Pipeline is a suite of plugins which supports implementing and integrating continuous delivery pipelines into Jenkins. Jenkins Pipeline is defined as the Jenkins file which is a groovy based script that lists the different stages and steps of the Jenkins build.
Versioning the Jenkinsfile to source code control provides several advantages, you can easily run pipeline for new branches, pull requests and track the changes on pipeline for audit, trail and code review purposes.

## High Level view of Jenkins Pipeline

![HigLevel](https://lh3.googleusercontent.com/kxpdBIOo8Ik4lGeQK9umiMceqUmB2SBMJMZSkXb9ayGg0KL28vO1mJFbIqKWFlLScvIl8iV7FYi1Ora9XaGUaBlc-iJTqwIcUVMP36Gxny9wi1a5Z9MF-h1OElNfyZSYaekctzD_A8k0Ph5FwMRpk9J-fLw1ZRGkD9MMvK4aMCW676yonhHcGVAWQ6st_i_pc9ExrLMKduObn9Db2FV3PA77wX0dYt0ZGwRLklgAKq4VmpyxIHTJmkCcr9FaSo21_tRTqV5OLhWPybxindwikhCIj_AESDcNdp250U3flICqHm-IWkrnjokJxhEjhLlRG_CP6njauVnNhTxBusAqw5ustyovHs437nIUpr3cqXzzwCuz9QSayQN4sZTvSzffFW34-COiE3YCZW8hvtCWNmKhmwdCOiBLh8lE6cEsBqr1_VHFEYjfN1UG_JpZhAz8qN2fTyvQfwyIVcODIUdZ9sFP-MHGx58_V7YXooume-L5U-oUwof5em5IZ5c8QRn63h8Erj3YC16mPM2jJfEg-WGmNnZ9asSXi5Cr0CjlPT-Rl-ASs9lF-5U1gWGLyqTMTwtEdpllB7Tz8ZosjlWC1n4bQepGYWMIrjOMIdsY0SpmcyfDKI6j2nrFRDMH3BfZ5AgSVgsgWpDlaC0IoTU9Jbd6kqDZwLp4jHZypW2nD4U819RTNk3YjLtzU5eBWLb9Oh_JiT02z_vBlHZL54L8emQoMwLtCd6W5MdrSi-IDOd9R8YV=w803-h540-no "high level view")

## Jenkins with Docker 

Jenkins need have installed docker inside it to execute Docker commands according to pipeline script directives.
https://hub.docker.com/r/jenkins/jenkins/ 

Pull jenkins image provided by jenkinsci and run image with below docker run options. Root user is required to execute root tasks inside the DockerFile of jenkins container. In order to avoid, var/run/docker.sock access denied or docker command not found docker run must be executed as shown below. You should have the root or sudo user on your environment. 

```
docker pull jenkins/jenkins

docker run -d -u root -p 9001:8080 -v $PWD/jenkins:/var/jenkins_home:z -t -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker jenkins/jenkins
```
