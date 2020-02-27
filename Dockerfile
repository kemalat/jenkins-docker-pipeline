FROM openjdk:8-jdk-alpine

MAINTAINER Kemal Atik <k.atik@oriontec.de>

# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

ADD target/classes/application.yml /app/application.yml
ADD target/springboot-docker-*.jar /app/springboot-docker.jar
ADD target/lib /app/lib
WORKDIR /app
RUN mkdir -p /app/tmp
# Web port.
EXPOSE 8081
ENTRYPOINT ["java","-cp","springboot-docker.jar:lib/*","hello.Application"]
