#!/bin/bash
#
#
DNS1=zentao.ipaas.zhonglele.com
DNSNAME1=zentao-ipaas-zhonglele
PROJECT1=product
TARGET1=zentao-8080-tcp
SERVICE1=product-zentao

DNS2=yuantianfu-test.ipaas.zhonglele.com
DNSNAME2=yuantianfu-test-ipaas-zhonglele
PROJECT2=test
TARGET2=yuantianfu2-8080-tcp
SERVICE2=test-yuantianfu2

DNS3=yuantianfu.ipaas.zhonglele.com
DNSNAME3=yuantianfu-ipaas-zhonglele
PROJECT3=product
TARGET3=yuantianfu2-8080-tcp
SERVICE3=product-yuantianfu2

DNS4=yuantianfu-dev.ipaas.zhonglele.com
DNSNAME4=yuantianfu-dev-ipaas-zhonglele
PROJECT4=dev
TARGET4=yuantianfu2-8080-tcp
SERVICE4=dev-yuantianfu2

DNS5=svn.ipaas.zhonglele.com
DNSNAME5=svn-ipaas-zhonglele
PROJECT5=cicd
TARGET5=subversion-80-tcp
SERVICE5=subversion

DNS6=nexus-cicd.ipaas.zhonglele.com
DNSNAME6=nexus-cicd-ipaas-zhonglele
PROJECT6=cicd
TARGET6=nexus-8081-tcp
SERVICE6=nexus

DNS7=jenkins-cicd.ipaas.zhonglele.com
DNSNAME7=jenkins-cicd-ipaas-zhonglele
PROJECT7=cicd
TARGET7=jenkins-8080-tcp
SERVICE7=jenkins

DNS8=gogs-cicd.ipaas.zhonglele.com
DNSNAME8=gogs-cicd-ipaas-zhonglele
PROJECT8=cicd
TARGET8=gogs-3000-tcp
SERVICE8=gogs

DNS9=static.ipaas.zhonglele.com
DNSNAME9=static-ipaas-zhonglele
PROJECT9=product
TARGET9=nginx-80-tcp
SERVICE9=nginx

for((i=1;i<10;i++)); do
cat > `eval echo '$DNSNAME'$i`-list.yaml << EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: Route
  metadata:
    name: `eval echo '$DNSNAME'$i`
    namespace: `eval echo '$PROJECT'$i`
    creationTimestamp: null
    labels:
      app: route-http
    annotations:
      description: Route for Jboss http service.
      openshift.io/host.generated: 'true'
  spec:
    host: `eval echo '$DNS'$i`
    port:
      targetPort: `eval echo '$TARGET'$i`
    to:
      kind: Service
      name: `eval echo '$SERVICE'$i`
      weight: 100
    wildcardPolicy: None
EOF
oc delete route/`eval echo '$DNSNAME'$i` -n product
oc project `eval echo '$PROJECT'$i`
oc delete route/`eval echo '$DNSNAME'$i` -n `eval echo '$PROJECT'$i`
oc create -f `eval echo '$DNSNAME'$i`-list.yaml -n `eval echo '$PROJECT'$i`
done
