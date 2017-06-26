#!/bin/bash
#
docker pull registry.access.redhat.com/jboss-eap-7/eap70-openshift:1.4-34
#docker pull docker.io/openshift/origin-pod:v1.4.1
#docker pull docker.io/openshift/origin-docker-registry:v1.4.1
#docker pull docker.io/openshift/origin-deployer:v1.4.1
#docker pull docker.io/openshift/origin-haproxy-router:v1.4.1
#docker pull docker.io/openshift/origin-sti-builder:v1.4.1
#docker pull docker.io/openshift/origin:v1.4.1
#docker pull docker.io/openshift/origin-logging-deployer:v1.4.1
#docker pull docker.io/openshift/origin-metrics-cassandra:v1.4.1
#docker pull docker.io/openshift/origin-metrics-deployer:v1.4.1
#docker pull docker.io/openshift/origin-metrics-hawkular-metrics:v1.4.1
#docker pull docker.io/openshift/origin-metrics-heapster:v1.4.1
docker pull docker.io/openshift/jenkins-2-centos7
docker pull docker.io/centos/postgresql-95-centos7
docker pull docker.io/centos/mysql-57-centos7
docker pull docker.io/centos/php-70-centos7
#docker pull docker.io/cockpit/kubernetes:latest
docker pull docker.io/gogs/gogs:0.11.4
docker pull docker.io/openshiftdemos/gogs:0.11.4
docker pull docker.io/sonatype/nexus:2.14.4
docker pull docker.io/sonarqube:6.3.1
docker pull docker.io/marvambass/subversion
docker pull docker.io/nginx:1.13
docker tag registry.access.redhat.com/jboss-eap-7/eap70-openshift:1.4-34 172.30.0.3:5000/openshift/jboss-eap70-openshift:1.4-34
#docker tag docker.io/openshift/origin-pod:v1.4.1 172.30.0.3:5000/openshift/origin-pod:v1.4.1
docker tag docker.io/openshift/origin-docker-registry:v1.4.1 172.30.0.3:5000/openshift/origin-docker-registry:v1.4.1
docker tag docker.io/openshift/origin-deployer:v1.4.1 172.30.0.3:5000/openshift/origin-deployer:v1.4.1
docker tag docker.io/openshift/origin-haproxy-router:v1.4.1 172.30.0.3:5000/openshift/origin-haproxy-router:v1.4.1
docker tag docker.io/openshift/origin-sti-builder:v1.4.1 172.30.0.3:5000/openshift/origin-sti-builder:v1.4.1
docker tag docker.io/openshift/origin:v1.4.1 172.30.0.3:5000/openshift/origin:v1.4.1
docker tag docker.io/openshift/origin-logging-deployer:v1.4.1 172.30.0.3:5000/openshift/origin-logging-deployer:v1.4.1
docker tag docker.io/openshift/origin-metrics-cassandra:v1.4.1 172.30.0.3:5000/openshift/origin-metrics-cassandra:v1.4.1
docker tag docker.io/openshift/origin-metrics-deployer:v1.4.1 172.30.0.3:5000/openshift/origin-metrics-deployer:v1.4.1
docker tag docker.io/openshift/origin-metrics-hawkular-metrics:v1.4.1 172.30.0.3:5000/openshift/origin-metrics-hawkular-metrics:v1.4.1
docker tag docker.io/openshift/origin-metrics-heapster:v1.4.1 172.30.0.3:5000/openshift/origin-metrics-heapster:v1.4.1
docker tag docker.io/openshift/jenkins-2-centos7 172.30.0.3:5000/openshift/jenkins-2-centos7
docker tag docker.io/centos/postgresql-95-centos7 172.30.0.3:5000/openshift/postgresql-95-centos7
docker tag docker.io/centos/mysql-57-centos7 172.30.0.3:5000/openshift/mysql-57-centos7
docker tag docker.io/centos/php-70-centos7 172.30.0.3:5000/openshift/php-70-centos7
docker tag docker.io/cockpit/kubernetes:latest 172.30.0.3:5000/openshift/kubernetes:latest
docker tag docker.io/gogs/gogs:0.11.4 172.30.0.3:5000/openshift/gogs:0.11.4
docker tag docker.io/openshiftdemos/gogs:0.11.4 172.30.0.3:5000/openshift/gogs-openshift:0.11.4
docker tag docker.io/sonatype/nexus:2.14.4 172.30.0.3:5000/openshift/nexus:2.14.4
docker tag docker.io/sonarqube:6.3.1 172.30.0.3:5000/openshift/sonarqube:6.3.1
docker tag docker.io/marvambass/subversion 172.30.0.3:5000/openshift/subversion
docker tag docker.io/nginx:1.13 172.30.0.3:5000/openshift/nginx:1.13
oc login -u zhonglele -n default
docker login -u zhonglele -p $(oc whoami -t) 172.30.0.3:5000
docker push 172.30.0.3:5000/openshift/jboss-eap70-openshift:1.4-34
docker push 172.30.0.3:5000/openshift/origin-pod:v1.4.1
docker push 172.30.0.3:5000/openshift/origin-docker-registry:v1.4.1
docker push 172.30.0.3:5000/openshift/origin-deployer:v1.4.1
docker push 172.30.0.3:5000/openshift/origin-haproxy-router:v1.4.1
docker push 172.30.0.3:5000/openshift/origin-sti-builder:v1.4.1
docker push 172.30.0.3:5000/openshift/origin:v1.4.1
docker push 172.30.0.3:5000/openshift/origin-logging-deployer:v1.4.1
docker push 172.30.0.3:5000/openshift/origin-metrics-cassandra:v1.4.1
docker push 172.30.0.3:5000/openshift/origin-metrics-deployer:v1.4.1
docker push 172.30.0.3:5000/openshift/origin-metrics-hawkular-metrics:v1.4.1
docker push 172.30.0.3:5000/openshift/origin-metrics-heapster:v1.4.1
docker push 172.30.0.3:5000/openshift/jenkins-2-centos7
docker push 172.30.0.3:5000/openshift/kubernetes:latest
docker push 172.30.0.3:5000/openshift/postgresql-95-centos7
docker push 172.30.0.3:5000/openshift/mysql-57-centos7
docker push 172.30.0.3:5000/openshift/php-70-centos7
docker push 172.30.0.3:5000/openshift/gogs:0.11.4
docker push 172.30.0.3:5000/openshift/gogs-openshift:0.11.4
docker push 172.30.0.3:5000/openshift/nexus:2.14.4
docker push 172.30.0.3:5000/openshift/sonarqube:6.3.1
docker push 172.30.0.3:5000/openshift/subversion
docker push 172.30.0.3:5000/openshift/nginx:1.13
