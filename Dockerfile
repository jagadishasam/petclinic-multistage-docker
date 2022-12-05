FROM ubuntu AS build
MAINTAINER devops
ARG MAVEN_VERSION="3.8.6"
RUN apt-get update -y && apt-get install openjdk-11-jdk -y && apt-get install wget -y &&  apt-get install unzip -y && apt-get install git -y
RUN java -version
#create a dir foe maven in opt
RUN wget  https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O maven.tar.gz
#extract the file
RUN tar -zxvf maven.tar.gz
RUN pwd && ls
RUN apache-maven-$MAVEN_VERSION/bin/mvn --version && cd /apache-maven-$MAVEN_VERSION/bin/ && pwd 
RUN git clone https://github.com/jagadishasam/petclinic-docker-mysql.git
RUN cd petclinic-docker-mysql && /apache-maven-$MAVEN_VERSION/bin/mvn clean install -P MySQL

FROM tomcat:9
COPY --from=build petclinic-docker-mysql/target/petclinic.war /usr/local/tomcat/webapps/
