#!/bin/bash

#download H3 subm
cd H3/
git submodule init
git submodule update

#download H3Jclouds subm
cd Jclouds-H3
git submodule init
git submodule update

#download s3proxy subm
cd s3proxy/
git submodule init
git submodule update
git checkout s3proxy-1.7.1

#edit s3proxy's pom adding h3
sed 's/<dependencies>/<dependencies>\r\n<!--H3Jclouds-->\r\n<dependency>\r\n<groupId>org.apache.jclouds.api<\/groupId>\r\n<artifactId>h3<\/artifactId>\r\n<version>${jclouds.version}<\/version>\r\n<\/dependency>\r\n<!--H3Jclouds-->/g' s3proxy/pom.xml > s3proxy/pom_new.xml
rm -f s3proxy/pom.xml
mv s3proxy/pom_new.xml s3proxy/pom.xml