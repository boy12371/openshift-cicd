#!/bin/bash
#
yum -y install etcd
systemctl start etcd.service
systemctl enable etcd.service
yum -y install origin-master-1.4.1-1.el7.x86_64 \
            origin-pod-1.4.1-1.el7.x86_64 \
            origin-sdn-ovs-1.4.1-1.el7.x86_64 \
            origin-dockerregistry-1.4.1-1.el7.x86_64
