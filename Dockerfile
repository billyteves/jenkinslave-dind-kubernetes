FROM billyteves/ubuntu-dind:16.04

MAINTAINER Billy Ray Teves <billyteves@gmail.com>

# Install necessary packages
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y \
    curl \
    zip \
    python \
    python-pip \
    openjdk-9-jre-headless \
    && pip install --upgrade pip \
    && pip install awscli \
    && apt-get remove --purge -y $BUILD_PACKAGES $(apt-mark showauto) \
    && rm -rf /var/lib/apt/lists/* \ 

ENV JENKINS_REMOTING_VERSION 3.7
ENV DOCKER_COMPOSE_VERSION 1.11.2
ENV KUBERNETES_CTL_VERSION v1.5.4
ENV HOME /home/jenkins

ADD jenkins-slave /usr/local/bin/jenkins-slave
ADD dockerconfig /tmp/dockerconfig

RUN curl --create-dirs -sSLo /usr/share/jenkins/remoting-$JENKINS_REMOTING_VERSION.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
    && curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_CTL_VERSION}/bin/linux/amd64/kubectl > /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/kubectl \
    && chmod +x /tmp/dockerconfig \
    && ln -s /tmp/dockerconfig /usr/local/bin/dockerconfig \
    && chmod 755 /usr/share/jenkins

VOLUME /home/jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
