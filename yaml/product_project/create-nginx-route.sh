#!/bin/bash
#
projectName=product
if [ "$(oc whoami)" != "system:admin" ]; then
  echo "Please create these apps by user system:admin."
  exit 0
elif [ "$(oc project -q)" != $projectName ]; then
  echo "Please using project $projectName create these apps."
  exit 0
fi
DNSNAME1=android-ipaas-zhonglele
DNS1=android.ipaas.zhonglele.com
DNSNAME2=android-zhonglele
DNS2=android.zhonglele.com
DNSNAME3=apps-ipaas-zhonglele
DNS3=apps.ipaas.zhonglele.com
DNSNAME4=apps-zhonglele
DNS4=apps.zhonglele.com
DNSNAME5=coc-dev-ipaas-zhonglele
DNS5=coc-dev.ipaas.zhonglele.com
DNSNAME6=coc-ipaas-zhonglele
DNS6=coc.ipaas.zhonglele.com
DNSNAME7=coc-test-ipaas-zhonglele
DNS7=coc-test.ipaas.zhonglele.com
DNSNAME8=coc-zhonglele
DNS8=coc.zhonglele.com
DNSNAME9=dns-ipaas-zhonglele
DNS9=dns.ipaas.zhonglele.com
DNSNAME10=dns-zhonglele
DNS10=dns.zhonglele.com
DNSNAME11=email-ipaas-zhonglele
DNS11=email.ipaas.zhonglele.com
DNSNAME12=email-zhonglele
DNS12=email.zhonglele.com
DNSNAME13=etcd-ipaas-zhonglele
DNS13=etcd.ipaas.zhonglele.com
DNSNAME14=etcd-zhonglele
DNS14=etcd.zhonglele.com
DNSNAME15=etcd0-ipaas-zhonglele
DNS15=etcd0.ipaas.zhonglele.com
DNSNAME16=etcd1-ipaas-zhonglele
DNS16=etcd1.ipaas.zhonglele.com
DNSNAME17=etcd2-ipaas-zhonglele
DNS17=etcd2.ipaas.zhonglele.com
DNSNAME18=finance-dev-ipaas-zhonglele
DNS18=finance-dev.ipaas.zhonglele.com
DNSNAME19=finance-ipaas-zhonglele
DNS19=finance.ipaas.zhonglele.com
DNSNAME20=finance-test-ipaas-zhonglele
DNS20=finance-test.ipaas.zhonglele.com
DNSNAME21=finance-zhonglele
DNS21=finance.zhonglele.com
DNSNAME22=ftp-ipaas-zhonglele
DNS22=ftp.ipaas.zhonglele.com
DNSNAME23=ftp-zhonglele
DNS23=ftp.zhonglele.com
DNSNAME24=git-ipaas-zhonglele
DNS24=git.ipaas.zhonglele.com
DNSNAME25=git-zhonglele
DNS25=git.zhonglele.com
DNSNAME26=gogs-cicd-ipaas-zhonglele
DNS26=gogs-cicd.ipaas.zhonglele.com
DNSNAME27=gogs-ipaas-zhonglele
DNS27=gogs.ipaas.zhonglele.com
DNSNAME28=gogs-zhonglele
DNS28=gogs.zhonglele.com
DNSNAME29=ios-ipaas-zhonglele
DNS29=ios.ipaas.zhonglele.com
DNSNAME30=ios-zhonglele
DNS30=ios.zhonglele.com
DNSNAME31=ipaas-zhonglele
DNS31=ipaas.zhonglele.com
DNSNAME32=jenkins-cicd-ipaas-zhonglele
DNS32=jenkins-cicd.ipaas.zhonglele.com
DNSNAME33=jenkins-ipaas-zhonglele
DNS33=jenkins.ipaas.zhonglele.com
DNSNAME34=jenkins-zhonglele
DNS34=jenkins.zhonglele.com
DNSNAME35=master-ipaas-zhonglele
DNS35=master.ipaas.zhonglele.com
DNSNAME36=master-zhonglele
DNS36=master.zhonglele.com
DNSNAME37=master0-ipaas-zhonglele
DNS37=master0.ipaas.zhonglele.com
DNSNAME38=master1-ipaas-zhonglele
DNS38=master1.ipaas.zhonglele.com
DNSNAME39=master2-ipaas-zhonglele
DNS39=master2.ipaas.zhonglele.com
DNSNAME40=memcache-base-ipaas-zhonglele
DNS40=memcache-base.ipaas.zhonglele.com
DNSNAME41=memcache-ipaas-zhonglele
DNS41=memcache.ipaas.zhonglele.com
DNSNAME42=memcache-zhonglele
DNS42=memcache.zhonglele.com
DNSNAME43=mq-base-ipaas-zhonglele
DNS43=mq-base.ipaas.zhonglele.com
DNSNAME44=mq-ipaas-zhonglele
DNS44=mq.ipaas.zhonglele.com
DNSNAME45=nexus-cicd-ipaas-zhonglele
DNS45=nexus-cicd.ipaas.zhonglele.com
DNSNAME46=nexus-ipaas-zhonglele
DNS46=nexus.ipaas.zhonglele.com
DNSNAME47=nexus-zhonglele
DNS47=nexus.zhonglele.com
DNSNAME48=nginx-ipaas-zhonglele
DNS48=nginx.ipaas.zhonglele.com
DNSNAME49=nginx-zhonglele
DNS49=nginx.zhonglele.com
DNSNAME50=node-ipaas-zhonglele
DNS50=node.ipaas.zhonglele.com
DNSNAME51=node-zhonglele
DNS51=node.zhonglele.com
DNSNAME52=node0-ipaas-zhonglele
DNS52=node0.ipaas.zhonglele.com
DNSNAME53=node1-ipaas-zhonglele
DNS53=node1.ipaas.zhonglele.com
DNSNAME54=node2-ipaas-zhonglele
DNS54=node2.ipaas.zhonglele.com
DNSNAME55=redis-base-ipaas-zhonglele
DNS55=redis-base.ipaas.zhonglele.com
DNSNAME56=redis-ipaas-zhonglele
DNS56=redis.ipaas.zhonglele.com
DNSNAME57=solr-base-ipaas-zhonglele
DNS57=solr-base.ipaas.zhonglele.com
DNSNAME58=solr-ipaas-zhonglele
DNS58=solr.ipaas.zhonglele.com
DNSNAME59=sonarqube-cicd-ipaas-zhonglele
DNS59=sonarqube-cicd.ipaas.zhonglele.com
DNSNAME60=sonarqube-ipaas-zhonglele
DNS60=sonarqube.ipaas.zhonglele.com
DNSNAME61=sonarqube-zhonglele
DNS61=sonarqube.zhonglele.com
DNSNAME62=sso-dev-ipaas-zhonglele
DNS62=sso-dev.ipaas.zhonglele.com
DNSNAME63=sso-test-ipaas-zhonglele
DNS63=sso-test.ipaas.zhonglele.com
DNSNAME64=sso-zhonglele
DNS64=sso.zhonglele.com
DNSNAME65=sso-ipaas-zhonglele
DNS65=sso.ipaas.zhonglele.com
DNSNAME66=static-ipaas-zhonglele
DNS66=static-ipaas-zhonglele.com
DNSNAME67=static-zhonglele
DNS67=static.zhonglele.com
DNSNAME68=subversion-ipaas-zhonglele
DNS68=subversion.ipaas.zhonglele.com
DNSNAME69=subversion-zhonglele
DNS69=subversion.zhonglele.com
DNSNAME70=svn-ipaas-zhonglele
DNS70=svn.ipaas.zhonglele.com
DNSNAME71=svn-zhonglele
DNS71=svn.zhonglele.com
DNSNAME72=www-ipaas-zhonglele
DNS72=www.ipaas.zhonglele.com
DNSNAME73=www-zhonglele
DNS73=www.zhonglele.com
DNSNAME74=wx-ipaas-zhonglele
DNS74=wx.ipaas.zhonglele.com
DNSNAME75=wx-zhonglele
DNS75=wx.zhonglele.com
DNSNAME76=yuantianfu-dev-ipaas-zhonglele
DNS76=yuantianfu-dev.ipaas.zhonglele.com
DNSNAME77=yuantianfu-ipaas-zhonglele
DNS77=yuantianfu.ipaas.zhonglele.com
DNSNAME78=yuantianfu-test-ipaas-zhonglele
DNS78=yuantianfu-test.ipaas.zhonglele.com
DNSNAME79=yuantianfu-zhonglele
DNS79=yuantianfu.zhonglele.com
DNSNAME80=yuntianfu-ipaas-zhonglele
DNS80=yuntianfu.ipaas.zhonglele.com
DNSNAME81=yuntianfu-zhonglele
DNS81=yuntianfu.zhonglele.com
DNSNAME82=zentao-ipaas-zhonglele
DNS82=zentao.ipaas.zhonglele.com
DNSNAME83=zentao-zhonglele
DNS83=zentao.zhonglele.com
DNSNAME84=zhonglele
DNS84=zhonglele.com
for((i=1;i<85;i++)); do
cat > product-nginx-http-route-list.yaml << EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: Route
  metadata:
    name: `eval echo '$DNSNAME'$i`
    namespace: product
    creationTimestamp: null
    labels:
      app: nginx-http
    annotations:
      description: Route for Jboss http service.
      openshift.io/host.generated: 'true'
  spec:
    host: `eval echo '$DNS'$i`
    port:
      targetPort: nginx-80-tcp
    to:
      kind: Service
      name: nginx
      weight: 100
    wildcardPolicy: None
EOF
oc create -f product-nginx-http-route-list.yaml
done
