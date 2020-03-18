# jenkins-pipeline-build-dockerize-run

A continuous delivery (CD) pipeline is an automated process for getting software from version control and building the 
software through multiple stages of testing and deployment. Jenkins Pipeline is a suite of plugins which supports implementing and integrating continuous delivery pipelines into Jenkins. Jenkins Pipeline is defined as the Jenkins file which is a groovy based script that lists the different stages and steps of the Jenkins build.
Versioning the Jenkinsfile to source code control provides several advantages, you can easily run pipeline for new branches, pull requests and track the changes on pipeline for audit, trail and code review purposes.

## High Level view of Jenkins Pipeline

![HigLevel](https://lh3.googleusercontent.com/kxpdBIOo8Ik4lGeQK9umiMceqUmB2SBMJMZSkXb9ayGg0KL28vO1mJFbIqKWFlLScvIl8iV7FYi1Ora9XaGUaBlc-iJTqwIcUVMP36Gxny9wi1a5Z9MF-h1OElNfyZSYaekctzD_A8k0Ph5FwMRpk9J-fLw1ZRGkD9MMvK4aMCW676yonhHcGVAWQ6st_i_pc9ExrLMKduObn9Db2FV3PA77wX0dYt0ZGwRLklgAKq4VmpyxIHTJmkCcr9FaSo21_tRTqV5OLhWPybxindwikhCIj_AESDcNdp250U3flICqHm-IWkrnjokJxhEjhLlRG_CP6njauVnNhTxBusAqw5ustyovHs437nIUpr3cqXzzwCuz9QSayQN4sZTvSzffFW34-COiE3YCZW8hvtCWNmKhmwdCOiBLh8lE6cEsBqr1_VHFEYjfN1UG_JpZhAz8qN2fTyvQfwyIVcODIUdZ9sFP-MHGx58_V7YXooume-L5U-oUwof5em5IZ5c8QRn63h8Erj3YC16mPM2jJfEg-WGmNnZ9asSXi5Cr0CjlPT-Rl-ASs9lF-5U1gWGLyqTMTwtEdpllB7Tz8ZosjlWC1n4bQepGYWMIrjOMIdsY0SpmcyfDKI6j2nrFRDMH3BfZ5AgSVgsgWpDlaC0IoTU9Jbd6kqDZwLp4jHZypW2nD4U819RTNk3YjLtzU5eBWLb9Oh_JiT02z_vBlHZL54L8emQoMwLtCd6W5MdrSi-IDOd9R8YV=w803-h540-no "high level view")


## Prerequisities 
- Docker Desktop should be installed and in running state
- root user or sudo user with administrative rights
- internet access
- Java 8 or higher
- Java IDE environment
- Maven 3
- Jenkins Docker image


## Jenkins with Docker 

## Pull from Docker Hub and Run

Jenkins pipeline needs to run inside  Docker container which have Docker installed in order to execute Docker commands

https://hub.docker.com/r/jenkins/jenkins/ 

Pull jenkins image provided by jenkinsci and run image with below docker run options. Root user is required to execute root tasks inside the DockerFile of jenkins container. In order to avoid, var/run/docker.sock access denied or docker command not found docker run must be executed as shown below. You should have the root or sudo user on your environment. 

```
docker pull jenkins/jenkins

docker run -d -u root -p 9001:8080 -v $PWD/jenkins:/var/jenkins_home:z -t -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker jenkins/jenkins

```

After starting your docker container, you can stop and start later the same container using the container id. After stopping the instance if you execute docker run again, docker container will start another Jenkins installation from the scratch and you will lose your installed plugins and configuration. Note the container id and perform stop and start for further use.


```bash
$ docker container ls
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                               NAMES
9c6517f1b294        jenkins/jenkins     "/sbin/tini -- /usr/…"   3 days ago          Up 52 minutes       50000/tcp, 0.0.0.0:9001->8080/tcp   compassionate_moser
```

```bash
docker stop 9c6517f1b294
docker start 9c6517f1b294
```

After runnning the docker image, other installation steps are pretty straight forward and you can find instructions on internet everywhere. You can review the Jenkinsfile to see the flow in details. 

## Create pipeline using Jenkinsfile from Git Repository
Here are the simple steps for creating pipeline. 
1. New Item

![Dashboard](https://lh3.googleusercontent.com/gnAZYJ2d_8UmV2DJeQ-fN892ertIDoqfiEu_K47fU0n_lJBaljjUcrD0RFPvBoApeE1AxZ4Wu7cK3n_m0JIxA-A7V_ApRP4TvLT1PeNkaetdumTwGbK47krVUIrP6peSk9BiTjgNy15xbolYQ8Im52HOvkz_bJZFsn8wFPgEFe_aedo9sRQY4m-L0jm2ObpfL_bdEM4L_wKc16mXqW99Q_FuFdja5V9up98NVuM8-0O1_OcdelX7uNCf9PgO0XweFenDD0XWCfXMmrz5mtB5uHgGeEwZsMeRQY9sNOgAV6oiDiYklzXdyaC_84Q2OlEgbqwMWZDB9q2vDPLJO1OYGUEfkR1GfaASV_Bdmt9yvqUqaFS42KRokxdNZkVcIDshtcoz3B_zt57kzPcFyEUTEYSLzIS4xPYr2vNY4q5-QTnJhDjloDdeDWgXWpteYco_ZzOujlj8Vqpeh74Pk2FM3lwqlyCVwoSx1khBGLSu5109DnUmRrg38ufQhcm8l1aaZBQohoFj8CIqr1Yug2ilWmuG-dJdvnE7A0QYcxx8p0zrjNB8CIq_4mP0-6K0oqxfsvwaDsVOYockFP3KABF7lbVoMngiWBmON-tXTsWx5A44YTbNdDwu_N1MuiKyPYX3DmRdsae7KPsR24FtmeT4hxcObmdy7h0uw4V0XpA7S5gd7ao419PYlRI2N56TSYHBLJARpSRegRJjyfoypGpKI-GgnoNHhEx807EH_CSyDRvOzlft=w868-h459-no "Dashboard")

2. Pipeline Type Item Creation

![Pipeline](https://lh3.googleusercontent.com/bUB8BjJCEmogyx6asXqbNMYlTJ5ZbAoFLivLn6rrZ3xCBFKLlH6fBJEy6ciIK3nE_IEY-cwAVxcAZCJ2RJz-FA4SehbubBnvKSh1dbwsdb9w5xr1Cvz9czYZPoeRPupQ2NSkrAMzb4e0xwuIb-jhfKdf_Bj0uaqEDxNGxgw0YIq00myAjyeQtHuscF7ms-jFzRoVgieGfxXljJ5p3vtUQGFiaiHlNTrQQI6kdJSJvfVQyeAxpQE-HLaZsFWhHQNqUKviFSGtu4RuFQYsUF07y0Ipcif-vJhILs5LE7eVaDCxvxJDBtmU8Y6iKLWW1p5pAeQoySXC1ywQ5KguyeOb5aUXSskpjBzMeKNg6YzLW556LjPHPdvxx_xsYRatUozqedo1JA9eQKq8D5_ruTXVwFvjxhNT3tfGVPsxgXihHY7yWnsfv_eXAxEFXkZ2TwrwqpCTN9yxe2_T-vz6e_SkmcMPmHMtVLf-lRWy0TJX4p1HBCVUe_klpneK7UsTb4VCDLFDm-zKYnuryRfXmde5dH2kbX9zpzcYMwzU8hcthS-EDEeROc-VUrkcMDmd7FJ9mtoMbCE1xtTG8aguWgWqmpcpuHgicdVf5Zhw6s9ONxMy6weSPS4LxbuzwRq350aDNWP-z2VaI2sUS09VkjEv5_lD7UJ6vMbnAdI_5T-IWaRjGPBacoSzGzwiJaQkoX1b17TeiHCc5IES_XigVSH5ErP1Ods6MQqkZyYpSkjPOAIfBCuT=w1736-h1184-no "Pipeline Item")

3.Pipeline Script(Jenkinsfile) from SCM

![Pipeline %50](https://lh3.googleusercontent.com/z-DAbOBu5fpFD12rZZCo2OE0xJK1Sfz1jPfpYNR79m0DGB6C4y8N_ImwWSI9GD4_G3oNUWz3a8arHYRWvuBCFxcrzJsk_aQCLFK2bKxRkU2BC6j8FWiy1_nsTAXnueHuDlR7EUiQfV0MRfXscXrfuFoQb61kjaEv16cKbdPWPUFbznE8vGlZz6GLeqzW2qThvOQ-WUfjbc2tp0ue8bzqzWnHEf98X30rb5DVIOTQHWbGWJGvWG0wg1TxtxhRlRiF3E7CJPmk3hdaUb5SwNdTvyM8BRmyDjvNeqc4ImnlF0h3VMOC1dIfO2AFrRLrH2xcigTkkEuQd2HCBXuynIQUG0WKp4wds5j7Fte3Pm4EaHv9vLJ-KjQUY58-1xrH_IvLhKgrrbNx3lWS_ZOCck1hu8rMyngkAqJYfl7cSIXWtpEAgbq5uAxPBOv3WeRmnb3rMmB3qfRa9pZ_1Sa3jjsYT0rELozsA7Yn78R8Z_GjG9dloeJaG82wOe2_SGuho56_VC_Te3KWDzmgAvDF-cZXgInth6attibS16L0fldqHL77LUYLtss9t_ESGu7QxR7A8ObhyEtm8nsNJ-jhfB8L_vaOfczE7-yj1GP4BjPGWsqHYq_P21Ke84EVj88IHsqXbGuSB1hPUq9F5tpYh0YjkDyFbOymfyPvEeW-m1UjmaI0oLluzP4K8_qX5j35I1vUNBXBk2Ldk0ucIcKKr4Nv8f7XfZFdzxHc4ccEzC68NhMb0lcz=w1360-h1184-no "Jenkinsfile from Git")




