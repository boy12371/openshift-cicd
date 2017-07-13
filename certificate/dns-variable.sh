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
DEV5='console'

PARAM1='android'
PARAM2='apps'
PARAM3='dns'
PARAM4='email'
PARAM5='ftp'
PARAM6='git'
PARAM7='ios'
PARAM8='etcd0'
PARAM9='etcd1'
PARAM10='etcd2'
PARAM11='master0'
PARAM12='master1'
PARAM13='master2'
PARAM14='node0'
PARAM15='node1'
PARAM16='node2'
PARAM17='static'
PARAM18='svn'
PARAM19='www'
PARAM20='wx'

num=1
DODNS1=$1
DODNS2='ipaas.'$1
for ((z=1;z<3;z++)); do
  if [ $z -ge 2 ]; then num=50; fi
  n=1
  for ((a=$num;a<$[num+6];a++ && n++)); do
    eval DNS$a='$BASE'$n-$PROJECT1.'$DODNS'$z
    eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
  done
  n=1
  for ((a=$[num+6];a<$[num+11];a++ && n++)); do
    eval DNS$a='$CICD'$n-$PROJECT2.'$DODNS'$z
    eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
  done
  n=1
  for ((a=$[num+11];a<$[num+13];a++ && n++)); do
    eval DNS$a='$PRODUCT'$n.'$DODNS'$z
    eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
  done
  n=1 && m=3
  for ((a=$[num+13];a<$[num+28];a++ && n++ && m++)); do
    if [ $n -ge 5 ]; then n=1; fi
    if [ $m -ge 6 ]; then m=3; fi
    if [ $m -eq 3 ]; then
        eval DNS$a='$DEV'$n.'$DODNS'$z
        eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
    else
        eval DNS$a='$DEV'$n-'$PROJECT'$m.'$DODNS'$z
        eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
    fi
  done
  n=1
  for ((a=$[num+28];a<$[num+48];a++ && n++)); do
    eval DNS$a='$PARAM'$n.'$DODNS'$z
    eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
  done
  eval DNS$a='$DODNS'$z
  eval DNSNAME$a=`eval echo '${DNS'$a'//./-}'`
done
# for ((n=1;n<85;n++)); do eval echo '$DNSNAME'$n; done

# DNS.7 = nexus-cicd.zhonglele.com
DNNS1=$DNS7
DNNSNAME1=$DNSNAME7
PROJ1=$PROJECT2
TARGET1=$CICD1-8081-tcp
SERVICE1=$CICD1

# DNS.8 = gogs-cicd.zhonglele.com
DNNS2=$DNS8
DNNSNAME2=$DNSNAME8
PROJ2=$PROJECT2
TARGET2=$CICD2-3000-tcp
SERVICE2=$CICD2

# DNS.9 = jenkins-cicd.zhonglele.com
DNNS3=$DNS9
DNNSNAME3=$DNSNAME9
PROJ3=$PROJECT2
TARGET3=$CICD3-8080-tcp
SERVICE3=$CICD3

# DNS.10 = subversion-cicd.zhonglele.com
DNNS4=$DNS10
DNNSNAME4=$DNSNAME10
PROJ4=$PROJECT2
TARGET4=$CICD4-80-tcp
SERVICE4=$CICD4

# DNS.11 = sonarqube-cicd.zhonglele.com
DNNS5=$DNS11
DNNSNAME5=$DNSNAME11
PROJ5=$PROJECT2
TARGET5=$CICD5-9000-tcp
SERVICE5=$CICD5

# DNS.12 = zentao.zhonglele.com
DNNS6=$DNS12
DNNSNAME6=$DNSNAME12
PROJ6=$PROJECT3
TARGET6=$PRODUCT1-8080-tcp
SERVICE6=$PRODUCT1

# DNS.13 = nginx.zhonglele.com
DNNS7=$DNS13
DNNSNAME7=$DNSNAME13
PROJ7=$PROJECT3
TARGET7=$PRODUCT2-80-tcp
SERVICE7=$PRODUCT2

# DNS.14 = yuantianfu.zhonglele.com
DNNS8=$DNS14
DNNSNAME8=$DNSNAME14
PROJ8=$PROJECT3
TARGET8=$DEV1-8080-tcp
SERVICE8=$PROJECT3-$DEV1

# DNS.15 = finance-dev.zhonglele.com
DNNS9=$DNS15
DNNSNAME9=$DNSNAME15
PROJ9=$PROJECT4
TARGET9=$DEV2-8080-tcp
SERVICE9=$PROJECT4-$DEV2

# DNS.16 = sso-test.zhonglele.com
DNNS10=$DNS16
DNNSNAME10=$DNSNAME16
PROJ10=$PROJECT5
TARGET10=$DEV3-8080-tcp
SERVICE10=$PROJECT5-$DEV3

# DNS.17 = coc.zhonglele.com
DNNS11=$DNS17
DNNSNAME11=$DNSNAME17
PROJ11=$PROJECT3
TARGET11=$DEV4-8080-tcp
SERVICE11=$PROJECT3-$DEV4

# DNS.18 = yuantianfu-dev.zhonglele.com
DNNS12=$DNS18
DNNSNAME12=$DNSNAME18
PROJ12=$PROJECT4
TARGET12=$DEV1-8080-tcp
SERVICE12=$PROJECT4-$DEV1

# DNS.19 = finance-test.zhonglele.com
DNNS13=$DNS19
DNNSNAME13=$DNSNAME19
PROJ13=$PROJECT5
TARGET13=$DEV2-8080-tcp
SERVICE13=$PROJECT5-$DEV2

# DNS.20 = sso.zhonglele.com
DNNS14=$DNS20
DNNSNAME14=$DNSNAME20
PROJ14=$PROJECT3
TARGET14=$DEV3-8080-tcp
SERVICE14=$PROJECT3-$DEV3

# DNS.21 = coc-dev.zhonglele.com
DNNS14=$DNS21
DNNSNAME14=$DNSNAME21
PROJ14=$PROJECT4
TARGET14=$DEV4-8080-tcp
SERVICE14=$PROJECT4-$DEV4

# DNS.22 = yuantianfu-test.zhonglele.com
DNNS15=$DNS22
DNNSNAME15=$DNSNAME22
PROJ15=$PROJECT5
TARGET15=$DEV1-8080-tcp
SERVICE15=$PROJECT5-$DEV1

# DNS.23 = finance.zhonglele.com
DNNS16=$DNS23
DNNSNAME16=$DNSNAME23
PROJ16=$PROJECT3
TARGET16=$DEV2-8080-tcp
SERVICE16=$PROJECT3-$DEV2

# DNS.24 = sso-dev.zhonglele.com
DNNS17=$DNS24
DNNSNAME17=$DNSNAME24
PROJ17=$PROJECT4
TARGET17=$DEV2-8080-tcp
SERVICE17=$PROJECT4-$DEV2

# DNS.25 = coc-test.zhonglele.com
DNNS18=$DNS25
DNNSNAME18=$DNSNAME25
PROJ18=$PROJECT5
TARGET18=$DEV3-8080-tcp
SERVICE18=$PROJECT5-$DEV3

# DNS.27 = apps.zhonglele.com
DNNS19=$DNS27
DNNSNAME19=$DNSNAME27
PROJ19=$PROJECT3
TARGET19=$PRODUCT2-80-tcp
SERVICE19=$PRODUCT2
PATHS19=/apps-download

# DNS.31 = git.zhonglele.com
DNNS20=$DNS31
DNNSNAME20=$DNSNAME31
PROJ20=$PROJECT3
TARGET20=$CICD2-3000-tcp
SERVICE20=$CICD2

# DNS.45 = static.zhonglele.com
DNNS21=$DNS45
DNNSNAME21=$DNSNAME45
PROJ21=$PROJECT3
TARGET21=$PRODUCT2-80-tcp
SERVICE21=$PRODUCT2

# DNS.49 = zhonglele.com
DNNS22=$DNS49
DNNSNAME22=$DNSNAME49
PROJ22=$PROJECT3
TARGET22=$PRODUCT2-80-tcp
SERVICE22=$PRODUCT2

# DNS.64 = yuantianfu.ipaas.zhonglele.com
# DNS.65 = finance-dev.ipaas.zhonglele.com
# DNS.66 = sso-test.ipaas.zhonglele.com
# DNS.67 = coc.ipaas.zhonglele.com
# DNS.68 = yuantianfu-dev.ipaas.zhonglele.com
# DNS.69 = finance-test.ipaas.zhonglele.com
# DNS.70 = sso.ipaas.zhonglele.com
# DNS.71 = coc-dev.ipaas.zhonglele.com
# DNS.72 = yuantianfu-test.ipaas.zhonglele.com
# DNS.73 = finance.ipaas.zhonglele.com
# DNS.74 = sso-dev.ipaas.zhonglele.com
# DNS.75 = coc-test.ipaas.zhonglele.com
# DNS.95 = static.ipaas.zhonglele.com
# console-dev.ipaas.zhonglele.com
# console-test.ipaas.zhonglele.com
# console.ipaas.zhonglele.com
