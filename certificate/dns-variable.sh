#!/bin/bash
#
PROJECT1='base'
PROJECT2='cicd'
PROJECT3='product'
PROJECT4='dev'
PROJECT5='test'

BASE1='activemq'
BASE2='memcache'
BASE3='redis'
BASE4='rabbitmq'
BASE5='solr'
BASE6='mysql'

CICD1='nexus'
CICD2='gogs'
CICD3='jenkins'
CICD4='subversion'
CICD5='sonarqube'

PRODUCT1='zentao'
PRODUCT2='nginx'

DEV1='yuantianfu'
DEV2='finance'
DEV3='sso'
DEV4='coc'

PARAM1='android'
PARAM2='apps'
PARAM3='dns'
PARAM4='email'
PARAM5='ftp'
PARAM6='git'
PARAM7='ios'
PARAM8='ipaas'
PARAM9='etcd'
PARAM10='etcd0'
PARAM11='etcd1'
PARAM12='etcd2'
PARAM13='master'
PARAM14='master0'
PARAM15='master1'
PARAM16='master2'
PARAM17='node'
PARAM18='node0'
PARAM19='node1'
PARAM20='node2'
PARAM21='static'
PARAM22='svn'
PARAM23='www'
PARAM24='wx'

num=1
for ((a=$num;a<$[num+6];a++)); do
  eval DNS$a='$BASE'$a-$PROJECT1.$1
  eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
done
n=1
for ((a=7;a<12;a++ && n++)); do
  eval DNS$a='$CICD'$n-$PROJECT2.$1
  eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
done
n=1
for ((a=12;a<14;a++ && n++)); do
  eval DNS$a='$PRODUCT'$n-$PROJECT3.$1
  eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
done
n=1 && m=3
for ((a=14;a<26;a++ && n++ && m++)); do
  if [ $n -ge 5 ]; then n=1; fi
  if [ $m -ge 6 ]; then m=3; fi
  eval DNS$a='$DEV'$n-'$PROJECT'$m.$1
  eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
done
n=1
for ((a=26;a<50;a++ && n++)); do
  eval DNS$a='$PARAM'$n-$PROJECT3.$1
  eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
done
eval DNS$a=$1
eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
# for ((n=1;n<85;n++)); do eval echo '$DNSNAME'$n; done

CNF='san.cnf'
ACME_DIR='/mnt/data/product-storage/nginx/html/.well-known/acme-challenge/'

DNNS1=$DNS82
DNNSNAME1=$DNSNAME82
PROJ1=$PROJECT3
TARGET1=$APP1-8080-tcp
SERVICE1=$PROJECT3-$APP1

DNNS2=$DNS78
DNNSNAME2=$DNSNAME78
PROJ2=$PROJECT5
TARGET2=$APP2-8080-tcp
SERVICE2=$PROJECT5-$APP2

DNNS3=$DNS77
DNNSNAME3=$DNSNAME77
PROJ3=$PROJECT3
TARGET3=$APP2-8080-tcp
SERVICE3=$PROJECT3-$APP2

DNNS4=$DNS76
DNNSNAME4=$DNSNAME76
PROJ4=$PROJECT4
TARGET4=$APP2-8080-tcp
SERVICE4=$PROJECT4-$APP2

DNNS5=$DNS70
DNNSNAME5=$DNSNAME70
PROJ5=$PROJECT2
TARGET5=subversion-80-tcp
SERVICE5=subversion

DNNS6=nexus-cicd.ipaas.zhonglele.com
DNNSNAME6=nexus-cicd-ipaas-zhonglele
PROJ6=$PROJECT2
TARGET6=nexus-8081-tcp
SERVICE6=nexus

DNNS7=jenkins-cicd.ipaas.zhonglele.com
DNNSNAME7=jenkins
PROJ7=$PROJECT2
TARGET7=jenkins-8080-tcp
SERVICE7=jenkins

DNNS8=gogs-cicd.ipaas.zhonglele.com
DNNSNAME8=gogs-cicd-ipaas-zhonglele
PROJ8=$PROJECT2
TARGET8=gogs-3000-tcp
SERVICE8=gogs

DNNS9=static.ipaas.zhonglele.com
DNNSNAME9=static-ipaas-zhonglele
PROJ9=$PROJECT3
TARGET9=nginx-80-tcp
SERVICE9=nginx
