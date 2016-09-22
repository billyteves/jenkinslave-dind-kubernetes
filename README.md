# jenkinslave-dind-kubernetes

A Docker Image which has a capability to run docker inside and is compatible with the Jenkins Kubernetes Plugin.
This Docker Image can be used as a Jenkins slave or a simple development container image.

The `jenkins-slave` script used is a mash-up of [`carlossg/jenkins-slave-docker`](https://github.com/carlossg/jenkins-slave-docker)
and [`jenkinsci/docker-jnlp-slave`](https://github.com/jenkinsci/docker-jnlp-slave)

Docker-in-Docker: Credits to Jerome Petazzoni [`jpetazzo/dind`](https://github.com/jpetazzo/dind)

## Purpose
The main purpose of the creation of this image is to be able to create a jenkins slave on-demand triggered by the Jenkins Kubernetes Plugin. The kubernetes plugin will create multiple kubernetes environment variables that will be use by the Jenkins Remoting Tool and connect to Jenkins Master via JNLP connection.

### Docker-in-Docker
As a jenkins-slave, SCM is part of the process. Each code repositories should be able to build images. Based on their Jenkinsfile or on the Pipeline script, the ability to build and test the image before pushing to a private/public docker registry.

### Kubectl
If the build image passed the testing and deployed to docker registry, the jenkinslave-dind-kubernetes should be able to deploy the created image using the kubectl command line interface (if invoked in Jenkinsfile or in Pipeline script).

### Additional Tools Included
* GIT
* Kubectl
* Docker Compose
* JRE

## Configuration Specifics

By default, JnlpProtocol3 is disabled due to the known stability and scalability issues.
You can enable this protocol on your own risk using the 
<code>JNLP_PROTOCOL_OPTS=-Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false</code> property.

## Running

To run a Docker container

    docker run --privileged billyteves/jenkinslave-dind-kubernetes -url http://jenkins-server:port <secret> <slave name>

If the command line options are not set it will try to use environment variables,
including Kubernetes set variables for services `jenkins` and `jenkins-slave`.

* `JENKINS_URL`: url for the Jenkins server
* `JENKINS_SERVICE_HOST` and `JENKINS_SERVICE_PORT`: will be used to compose the url if the previous is not present.
* `JENKINS_TUNNEL`: (`HOST:PORT`) connect to this slave host and port instead of Jenkins server
* `JENKINS_SLAVE_SERVICE_HOST` and `JENKINS_SLAVE_SERVICE_PORT`: will be used to compose the tunnel argument if the previous is not present.

To run a Docker container as develoment bash with no establishment of jenkins-slave connection:

    docker run --privileged billyteves/jenkinslave-dind-kubernetes bash

Using Jenkins Kubernetes Plugin Configuration

    to be followed ...

## Building

    docker build -t billyteves/jenkinslave-dind-kubernetes .
