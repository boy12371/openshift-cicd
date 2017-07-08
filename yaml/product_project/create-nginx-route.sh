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
DNS1=zhonglele.com
DNS2=ipaas.zhonglele.com
DNS3=www.zhonglele.com
DNS4=dns.zhonglele.com
DNS5=svn.zhonglele.com
DNS6=subversion.zhonglele.com
DNS7=static.zhonglele.com
DNS8=git.zhonglele.com
DNS9=apps.zhonglele.com
DNS10=yuantianfu.zhonglele.com
DNS11=yuntianfu.zhonglele.com
DNS12=finance.zhonglele.com
DNS13=zentao.zhonglele.com
DNS14=nginx.zhonglele.com
DNS15=jenkins.zhonglele.com
DNS16=gogs.zhonglele.com
DNS17=nexus.zhonglele.com
DNS18=sonarqube.zhonglele.com
DNS19=sso.zhonglele.com
DNS20=coc.zhonglele.com
DNS21=master.zhonglele.com
DNS22=node.zhonglele.com
DNS23=etcd.zhonglele.com
DNS24=email.zhonglele.com
DNS25=memcache.zhonglele.com
DNS26=ftp.zhonglele.com
DNS27=ios.zhonglele.com
DNS28=android.zhonglele.com
DNS29=wx.zhonglele.com
DNS30=www.ipaas.zhonglele.com
DNS31=dns.ipaas.zhonglele.com
DNS32=svn.ipaas.zhonglele.com
DNS33=subversion.ipaas.zhonglele.com
DNS34=static.ipaas.zhonglele.com
DNS35=git.ipaas.zhonglele.com
DNS36=apps.ipaas.zhonglele.com
DNS37=yuntianfu.ipaas.zhonglele.com
DNS38=finance.ipaas.zhonglele.com
DNS39=zentao.ipaas.zhonglele.com
DNS40=nginx.ipaas.zhonglele.com
DNS41=master.ipaas.zhonglele.com
DNS42=master0.ipaas.zhonglele.com
DNS43=master1.ipaas.zhonglele.com
DNS44=master2.ipaas.zhonglele.com
DNS45=node.ipaas.zhonglele.com
DNS46=node0.ipaas.zhonglele.com
DNS47=node1.ipaas.zhonglele.com
DNS48=node2.ipaas.zhonglele.com
DNS49=etcd.ipaas.zhonglele.com
DNS50=etcd0.ipaas.zhonglele.com
DNS51=etcd1.ipaas.zhonglele.com
DNS52=etcd2.ipaas.zhonglele.com
DNS53=email.ipaas.zhonglele.com
DNS54=memcache.ipaas.zhonglele.com
DNS55=ftp.ipaas.zhonglele.com
DNS56=ios.ipaas.zhonglele.com
DNS57=android.ipaas.zhonglele.com
DNS58=wx.ipaas.zhonglele.com
DNS59=redis.ipaas.zhonglele.com
DNS60=redis-base.ipaas.zhonglele.com
DNS61=mq.ipaas.zhonglele.com
DNS62=mq-base.ipaas.zhonglele.com
DNS63=memcache.ipaas.zhonglele.com
DNS64=memcache-base.ipaas.zhonglele.com
DNS65=solr.ipaas.zhonglele.com
DNS66=solr-base.ipaas.zhonglele.com
DNS67=gogs.ipaas.zhonglele.com
DNS68=gogs-cicd.ipaas.zhonglele.com
DNS69=jenkins.ipaas.zhonglele.com
DNS70=jenkins-cicd.ipaas.zhonglele.com
DNS71=nexus.ipaas.zhonglele.com
DNS72=nexus-cicd.ipaas.zhonglele.com
DNS73=sonarqube.ipaas.zhonglele.com
DNS74=sonarqube-cicd.ipaas.zhonglele.com
DNS75=yuantianfu-dev.ipaas.zhonglele.com
DNS76=yuantianfu-test.ipaas.zhonglele.com
DNS77=yuantianfu.ipaas.zhonglele.com
DNS78=finance-dev.ipaas.zhonglele.com
DNS79=finance-test.ipaas.zhonglele.com
DNS80=finance.ipaas.zhonglele.com
DNS81=coc-dev.ipaas.zhonglele.com
DNS82=coc-test.ipaas.zhonglele.com
DNS83=coc.ipaas.zhonglele.com
DNS84=sso-dev.ipaas.zhonglele.com
DNS85=sso-test.ipaas.zhonglele.com
DNS86=sso.ipaas.zhonglele.com

DNSNAME1=zhonglele
DNSNAME2=ipaas-zhonglele
DNSNAME3=www-zhonglele
DNSNAME4=dns-zhonglele
DNSNAME5=svn-zhonglele
DNSNAME6=subversion-zhonglele
DNSNAME7=static-zhonglele
DNSNAME8=git-zhonglele
DNSNAME9=apps-zhonglele
DNSNAME10=yuantianfu-zhonglele
DNSNAME11=yuntianfu-zhonglele
DNSNAME12=finance-zhonglele
DNSNAME13=zentao-zhonglele
DNSNAME14=nginx-zhonglele
DNSNAME15=jenkins-zhonglele
DNSNAME16=gogs-zhonglele
DNSNAME17=nexus-zhonglele
DNSNAME18=sonarqube-zhonglele
DNSNAME19=sso-zhonglele
DNSNAME20=coc-zhonglele
DNSNAME21=master-zhonglele
DNSNAME22=node-zhonglele
DNSNAME23=etcd-zhonglele
DNSNAME24=email-zhonglele
DNSNAME25=memcache-zhonglele
DNSNAME26=ftp-zhonglele
DNSNAME27=ios-zhonglele
DNSNAME28=android-zhonglele
DNSNAME29=wx-zhonglele
DNSNAME30=www-ipaas-zhonglele
DNSNAME31=dns-ipaas-zhonglele
DNSNAME32=svn-ipaas-zhonglele
DNSNAME33=subversion-ipaas-zhonglele
DNSNAME34=static-ipaas-zhonglele
DNSNAME35=git-ipaas-zhonglele
DNSNAME36=apps-ipaas-zhonglele
DNSNAME37=yuntianfu-ipaas-zhonglele
DNSNAME38=finance-ipaas-zhonglele
DNSNAME39=zentao-ipaas-zhonglele
DNSNAME40=nginx-ipaas-zhonglele
DNSNAME41=master-ipaas-zhonglele
DNSNAME42=master0-ipaas-zhonglele
DNSNAME43=master1-ipaas-zhonglele
DNSNAME44=master2-ipaas-zhonglele
DNSNAME45=node-ipaas-zhonglele
DNSNAME46=node0-ipaas-zhonglele
DNSNAME47=node1-ipaas-zhonglele
DNSNAME48=node2-ipaas-zhonglele
DNSNAME49=etcd-ipaas-zhonglele
DNSNAME50=etcd0-ipaas-zhonglele
DNSNAME51=etcd1-ipaas-zhonglele
DNSNAME52=etcd2-ipaas-zhonglele
DNSNAME53=email-ipaas-zhonglele
DNSNAME54=memcache-ipaas-zhonglele
DNSNAME55=ftp-ipaas-zhonglele
DNSNAME56=ios-ipaas-zhonglele
DNSNAME57=android-ipaas-zhonglele
DNSNAME58=wx-ipaas-zhonglele
DNSNAME59=redis-ipaas-zhonglele
DNSNAME60=redis-base-ipaas-zhonglele
DNSNAME61=mq-ipaas-zhonglele
DNSNAME62=mq-base-ipaas-zhonglele
DNSNAME63=memcache-ipaas-zhonglele
DNSNAME64=memcache-base-ipaas-zhonglele
DNSNAME65=solr-ipaas-zhonglele
DNSNAME66=solr-base-ipaas-zhonglele
DNSNAME67=gogs-ipaas-zhonglele
DNSNAME68=gogs-cicd-ipaas-zhonglele
DNSNAME69=jenkins-ipaas-zhonglele
DNSNAME70=jenkins-cicd-ipaas-zhonglele
DNSNAME71=nexus-ipaas-zhonglele
DNSNAME72=nexus-cicd-ipaas-zhonglele
DNSNAME73=sonarqube-ipaas-zhonglele
DNSNAME74=sonarqube-cicd-ipaas-zhonglele
DNSNAME75=yuantianfu-dev-ipaas-zhonglele
DNSNAME76=yuantianfu-test-ipaas-zhonglele
DNSNAME77=yuantianfu-ipaas-zhonglele
DNSNAME78=finance-dev-ipaas-zhonglele
DNSNAME79=finance-test-ipaas-zhonglele
DNSNAME80=finance-ipaas-zhonglele
DNSNAME81=coc-dev-ipaas-zhonglele
DNSNAME82=coc-test-ipaas-zhonglele
DNSNAME83=coc-ipaas-zhonglele
DNSNAME84=sso-dev-ipaas-zhonglele
DNSNAME85=sso-test-ipaas-zhonglele
DNSNAME86=sso-ipaas-zhonglele
for((i=1;i<86;i++)); do
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
      description: Route \for Jboss http service.
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
