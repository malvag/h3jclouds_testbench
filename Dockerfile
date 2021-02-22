# Multistage - Builder
FROM maven:3.5.0-jdk-8-alpine as s3proxy-builder

WORKDIR /root
COPY --from=malvag/h3 /root/.m2/ /root/.m2/

COPY s3proxy /opt/s3proxy/
WORKDIR /opt/s3proxy
RUN mvn package -DskipTests

################################################################################
# Builder image
################################################################################
FROM malvag/h3:latest as h3engine

WORKDIR /opt/s3proxy

COPY \
    --from=s3proxy-builder \
    /opt/s3proxy/target/s3proxy \
    /opt/s3proxy/keystore.jks \
    /opt/s3proxy/src/main/resources/run-docker-container.sh \
    /opt/s3proxy/

ENV \
    LOG_LEVEL="info" \
    S3PROXY_AUTHORIZATION="aws-v2-or-v4" \
    S3PROXY_IDENTITY="test:tester" \
    S3PROXY_CREDENTIAL="testing" \
    S3PROXY_CORS_ALLOW_ALL="false" \
    S3PROXY_CORS_ALLOW_ORIGINS="" \
    S3PROXY_CORS_ALLOW_METHODS="" \
    S3PROXY_CORS_ALLOW_HEADERS="" \
    S3PROXY_KEYSTORE_PATH="keystore.jks" \
    S3PROXY_KEYSTORE_PASSWORD="CARVICS" \
    S3PROXY_IGNORE_UNKNOWN_HEADERS="false" \
    JCLOUDS_PROVIDER="h3" \
    S3PROXY_ENDPOINT="https://0.0.0.0:8080" \
    JCLOUDS_REGION="" \
    JCLOUDS_KEYSTONE_VERSION="" \
    JCLOUDS_BASEDIR="file:///data/h3container" \
    JCLOUDS_KEYSTONE_SCOPE="" \
    JCLOUDS_KEYSTONE_PROJECT_DOMAIN_NAME="" \
    JAVA_HOME="/usr/lib/jvm/jre-11-openjdk" \
    PATH="$PATH:/usr/lib/jvm/jre-11-openjdk/bin"


EXPOSE 8080
VOLUME /data

#remove java's 1.8 symbolic link to let it bind with java 11 jre
RUN mkdir /data/h3container

ENTRYPOINT ["/opt/s3proxy/run-docker-container.sh"]