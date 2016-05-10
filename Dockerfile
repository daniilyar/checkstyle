FROM ubuntu:14.04
MAINTAINER 	Daniil Yaroslavtsev <dyaroslavtsev@confyrm.com>

ENV DEBIAN_FRONTEND noninteractive
ENV MAVEN_VERSION 3.3.9

# Java Version
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 45
ENV JAVA_VERSION_BUILD 14
ENV JAVA_PACKAGE jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install common apt packages
RUN apt-get update -qqy && apt-get -qqy install sudo wget unzip curl

# Download and unarchive Java
RUN curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie" \
  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz \
    | gunzip -c - | tar -xf - -C /opt && \
    mkdir -p ${JAVA_HOME} && rmdir ${JAVA_HOME} && \
    ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME} && \
    ln -s /usr/lib/jvm/java-8-oracle/bin/* /bin/

# Add Java to PATH
ENV PATH ${PATH}:${JAVA_HOME}/bin

# Install Maven
RUN cd /opt && wget -q http://apache.volia.net/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip -O /apache-maven.zip && \
    unzip /apache-maven.zip -d / && rm -rf /apache-maven.zip && ln -s /apache-maven-${MAVEN_VERSION}/bin/mvn /bin/mvn

RUN mkdir /checkstyle && wget -q https://github.com/checkstyle/checkstyle/archive/master.zip -O /checkstyle/master.zip && \
    unzip /checkstyle/master.zip -d /checkstyle && rm -rf /checkstyle/master.zip && mv /checkstyle/checkstyle-master/* /checkstyle && rm -rf /checkstyle/checkstyle-master

# Compile
RUN cd /checkstyle && mvn install
