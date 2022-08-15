## Start with the official image (lightweight Debian)
ARG DOCKER_IMAGE
FROM $DOCKER_IMAGE

MAINTAINER support@odysseusinc.com

## gnupg is needed to add new key
RUN apt-get update && apt-get install -y gnupg2 software-properties-common libgdal-dev libproj-dev libbz2-dev

## Install Java and git
RUN apt-get install -y git openjdk-8-jdk wget

## make sure Java can be found in rApache and other daemons not looking in R ldpaths
RUN echo "/usr/lib/jvm/java-8-oracle/jre/lib/amd64/server/" > /etc/ld.so.conf.d/rJava.conf
RUN /sbin/ldconfig

## Install rJava package
RUN install2.r --error rJava \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
  
# Install Zulu CEK for OpenJDK
RUN wget http://cdn.azul.com/zcek/bin/ZuluJCEPolicies.zip \
        && echo "8021a28b8cac41b44f1421fd210a0a0822fcaf88d62d2e70a35b2ff628a8675a  ZuluJCEPolicies.zip" | sha256sum -c - \
        && unzip -oj ZuluJCEPolicies.zip ZuluJCEPolicies/local_policy.jar -d /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/ \
        && unzip -oj ZuluJCEPolicies.zip ZuluJCEPolicies/US_export_policy.jar -d /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/ \
        && rm -f ZuluJCEPolicies.zip \
