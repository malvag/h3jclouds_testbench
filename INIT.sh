#!/bin/bash

#download H3, H3-Jclouds and S3Proxy subm
git submodule update --init --recursive
# -----------
#edit s3proxy's pom adding h3 dependency
sed 's/<dependencies>/<dependencies>\r\n<!--H3Jclouds-->\r\n<dependency>\r\n<groupId>org.apache.jclouds.api<\/groupId>\r\n<artifactId>h3<\/artifactId>\r\n<version>${jclouds.version}<\/version>\r\n<\/dependency>\r\n<!--H3Jclouds-->/g' s3proxy/pom.xml > s3proxy/pom_new.xml
rm -f s3proxy/pom.xml
mv s3proxy/pom_new.xml s3proxy/pom.xml
# -----------
#populate s3proxy with its config file / keystore
cp config/s3proxy.conf s3proxy/
cp config/keystore.jks s3proxy/
# ---------

#remove JH3lib from .dockerignore
sed '$d' H3/.dockerignore > H3/.dockerignore2 
rm -f H3/.dockerignore
mv H3/.dockerignore2 H3/.dockerignore

#add JH3 and JcloudsH3 projects to h3 image
echo "
RUN yum install -y java-8-openjdk-headless maven && yum clean all
COPY JH3lib /root/JH3lib/
#JH3 build
WORKDIR /root/JH3lib 
RUN mvn clean install

#H3Jclouds build with jdk8
COPY ../Jclouds-H3 /root/h3Jclouds/
WORKDIR /root/h3Jclouds 
RUN mvn clean install -DskipTests=true -Drat.skip=true -Dcheckstyle.skip=true

WORKDIR /root
RUN rm -rf JH3lib h3Jclouds" >> H3/Dockerfile