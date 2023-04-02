# Build base container
######################
FROM arm64v8/ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

## BASH
RUN echo "dash dash/sh boolean false" | debconf-set-selections \
    && dpkg-reconfigure dash

## General package configuration
RUN set -euxo pipefail \
    && sed -i -e 's#http://\(archive\|security\)#mirror://mirrors#' -e 's#/ubuntu/#/mirrors.txt#' /etc/apt/sources.list \
    && apt-get -y update && apt-get upgrade -y && apt-get -y --no-install-recommends install \
        acl \
        curl \
        gnupg2 \
        ssh-client \
        sudo \
        openjdk-11-jdk-headless \
        uuid-runtime \
        wget \
        unzip \
        ansible \
    && rm -rf /var/lib/apt/lists/* \
    # Setup rundeck user
    && adduser --gid 0 --shell /bin/bash --home /home/rundeck --gecos "" --disabled-password rundeck \
    && chmod 0775 /home/rundeck \
    && passwd -d rundeck \
    && addgroup rundeck sudo \
    && chmod g+w /etc/passwd

#remco build 
RUN curl --request GET -sL \
    --url 'https://github.com/tommasopoerio/remco/releases/download/v0.12.3/remco_0.12.3_linux_arm64.tar.gz'\
    --output 'remco.tar.gz'
RUN echo 'c206c5887f7252721b5ddf383e081c66fa51500a5ec2ca77c6be44f2fa12c70d  remco.tar.gz' > remco.tar.gz.sha
RUN sha256sum -c remco.tar.gz.sha
RUN tar xzvf remco.tar.gz  && cp remco_linux /usr/local/bin/remco


USER rundeck

WORKDIR /home/rundeck


# Update image apt packages
USER root
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

#RUN apt-get install -y libc6 libc-bin


USER rundeck

COPY --chown=rundeck:root .build .
RUN java -jar rundeck.war --installonly \
    # Create plugin folder
    && mkdir libext \
    # Adjust permissions for OpenShift
    && chmod -R 0775 libext server user-assets var

COPY --chown=rundeck:root remco /etc/remco
COPY --chown=rundeck:root lib docker-lib
COPY --chown=rundeck:root etc etc


RUN chmod -R 0775 etc

VOLUME ["/home/rundeck/server/data"]

EXPOSE 4440
ENTRYPOINT [ "/bin/sh", "docker-lib/entry.sh" ]
