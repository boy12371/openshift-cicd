#!/bin/bash
#
yum -y install epel-release
yum -y install centos-release-openshift-origin
yum -y install unzip wget git net-tools bind-utils iptables-services bridge-utils bash-completion
yum -y install httpd-tools docker python-cryptography pyOpenSSL.x86_64 ntp
yum -y install --disablerepo=epel ansible
