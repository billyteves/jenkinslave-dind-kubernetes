FROM billyteves/ubuntu-dind

MAINTAINER Billy Ray Teves <billyteves@gmail.com>

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    openjdk-8-jre-headless \
    && rm -rf /var/lib/apt/lists/*

ENV JENKINS_REMOTING_VERSION 2.9
ENV DOCKER_COMPOSE_VERSION 1.8.1
ENV KUBERNETES_CTL_VERSION v1.4.0
ENV HOME /home/jenkins

RUN curl --create-dirs -sSLo /usr/share/jenkins/remoting-$JENKINS_REMOTING_VERSION.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
  && chmod 755 /usr/share/jenkins

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_CTL_VERSION}/bin/linux/amd64/kubectl > /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/kubectl

ADD jenkins-slave /usr/local/bin/jenkins-slave

VOLUME /home/jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
