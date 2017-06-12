安装Openshift-origin-v1.4.1
==========================

## 1. 安装纯净的CentOS-7-x86_64-Minimal-1611.iso
**注意:**
* 记得给docker留一块硬盘;
* 更新系统；
* fdisk找回分区;
* 配置LVM;
* partprobe使新创建的分区在系统中立即生效;
* pvcreate, pvdisplay, vgcreate, vgdisplay, vgextend, vgscan, vgreduce;
```
#安装新系统前，必需先删除扩展逻辑分区
pvs -o+pv_used
#如果其他分区有足够空间，可以直接移动数据到其他分区，不需要指定分区，命令会自动分发
#当然也可以指定移动到分区：pvmove /dev/sdb1 /dev/sdd1
pvmove /dev/sdb1
#当这个分区没有被使用，可以直接被移除
vgreduce docker-vg /dev/sdb1
#主逻辑分区，可以直接移除
vgremove docker-vg /dev/sda3
#找回丢失的分区
fdisk -l
fdisk /dev/sda
#输入n, p, t, 8e, w
pvcreate /dev/sda3
vgextend cl /dev/sda3
lvcreate -n data -l 100%FREE cl
ls -al /dev/cl/
ls -al /dev/mapper/
mkfs.xfs /dev/mapper/cl-data
mkdir /mnt/data
echo '/dev/mapper/cl-data     /mnt/data               xfs     defaults        0 0' >> /etc/fstab
mount -a
#创建docker分区
fdisk -l /dev/sdb
pvdisplay
#如果该物理磁盘已经有pv，但没有vg，直接创建vg，否则先创建pv
pvcreate /dev/sdb1
vgcreate docker-vg /dev/sdb1
```

## 2. 安装工具仓库。
```
yum install epel-release
yum install centos-release-openshift-origin
```

## 3. 安装基本工具。
```
yum install unzip wget git net-tools bind-utils iptables-services bridge-utils bash-completion
yum install httpd-tools docker python-cryptography pyOpenSSL.x86_64 ntp
#注意：不要安装epel下的ansible
yum --disablerepo=epel install ansible
#远程登录尝试禁止超过3次
vi /etc/ssh/sshd_config
51   MaxAuthTries 4
#配置sshd长连接
121  TCPKeepAlive yes
126  ClientAliveInterval 30
127  ClientAliveCountMax 200
129  UseDNS no
systemctl restart sshd.service
#打开时间同步
systemctl start ntpd.service
systemctl enable ntpd.service
```

## 4. 打开SELINUX, iptables, sshd, NetworkManager, dnsmasq服务，关闭firewalld服务
```
semanage port -a -t ssh_port_t -p tcp 22
semanage port -l | grep ssh
sestatus -v | grep SELinux
getenforce
systemctl disable firewalld
systemctl stop firewalld
systemctl mask firewalld
systemctl enable iptables
systemctl start iptables
systemctl status firewalld iptables | grep Active -B3
systemctl enable dnsmasq.service
systemctl start dnsmasq.service
systemctl status NetworkManager dnsmasq | grep Active -B3
```

## 5. 配置docker-storage， Device Mapper启用direct-lvm mode
```
vi /etc/sysconfig/docker
4   OPTIONS='--selinux-enabled=false'
13  ADD_REGISTRY='--add-registry registry.access.redhat.com'
19  BLOCK_REGISTRY='--registry-mirror=https://pee6w651.mirror.aliyuncs.com --registry-mirror=http://aad0405c.m.daocloud.io --registry-mirror=http://hub-mirror.c.163.com --registry-mirror=https://docker.mirrors.ustc.edu.cn'
INSECURE_REGISTRY='--insecure-registry=172.30.0.0/16'
systemctl start docker
systemctl enable docker
docker info
vi /etc/sysctl.conf
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-ip6tables=1
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-arptables=1
sysctl -p /etc/sysctl.conf
cp /usr/lib/docker-storage-setup/docker-storage-setup /etc/sysconfig/
vi /etc/sysconfig/docker-storage-setup
15  DEVS=/dev/sdb
23  VG=docker-vg
systemctl stop docker
rm -rf /var/lib/docker
docker-storage-setup
#cat /etc/sysconfig/docker-storage
systemctl start docker
```

## 6. 配置iptables规则
```
#立即临时生效
iptables -I INPUT 1 -p TCP --dport 53 -j ACCEPT
iptables -I INPUT 1 -p UDP --dport 53 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 443 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 1936 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 8053 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 8443 -j ACCEPT
#永久生效
iptables-save > /etc/sysconfig/iptables
iptables -nL --line-number
#或者直接编辑
vi /etc/sysconfig/iptables
-A INPUT -p tcp -m tcp --dport 8443 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 1936 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -p udp -m udp --dport 53 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
iptables-restore /etc/sysconfig/iptables
```

## 7. 配置dnsmasq服务
```
vi /etc/sysconfig/network-scripts/ifcfg-enp0s3
17  #DNS1="210.22.70.3"
18  IPV6_PEERDNS="no"
21  PEERDNS="no"
22  NM_CONTROLLED="no"
vi /etc/resolv.conf
nameserver 210.22.70.3
nameserver 210.22.84.3
vi /etc/hosts
192.168.1.101   master0.ipaas.sveil.com
192.168.1.101   www.ipaas.sveil.com
192.168.1.101   node0.ipaas.sveil.com
192.168.1.101   dns.ipaas.sveil.com
192.168.1.101   kubernetes.default
192.168.1.101   kubernetes.default.svc.cluster.local
192.168.1.101   kubernetes
192.168.1.101   openshift.default
192.168.1.101   openshift.default.svc
192.168.1.101   openshift.default.svc.cluster.local
192.168.1.101   kubernetes.default.svc
192.168.1.101   openshift
192.168.1.101   nexus-cicd.master0.ipaas.sveil.com
192.168.1.101   svn.ipaas.sveil.com
192.168.1.101   nginx-dev.master0.ipaas.sveil.com
172.30.100.10   postgresql-gogs
172.30.100.11   gogs
172.30.100.12   nexus
172.30.100.13   postgresql-sonarqube
172.30.100.14   sonarqube
172.30.100.15   jenkins
172.30.100.16   jenkins-jnlp
172.30.100.16   zentao-mysql
172.30.100.17   svn
hostnamectl --static set-hostname master0.ipaas.sveil.com
ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''
ssh-copy-id root@master0.ipaas.sveil.com
#把私钥复制到本地后禁止远程使用口令登录
vi /etc/ssh/sshd_config
77 PasswordAuthentication no
systemctl restart sshd.service
#编辑本地ssh配置文件
vi ~/.ssh/config
Host 192.168.1.101
  HostName master0.ipaas.sveil.com
  User root
  IdentityFile ~/.ssh/ipaas.sveil
rpm -qc dnsmasq
#添加本地DNS Server
vi /etc/dnsmasq.d/origin-dns.conf
strict-order                             #遵循/etc/resolv.conf
no-negcache                              #错误不缓存
domain-needed                            #不转发格式错误的域名
cache-size=5000                          #缓存记录数
local=/sveil.com/
server=/cluster.local/172.30.0.1         #增加一个nameserver
server=/30.172.in-addr.arpa/172.30.0.1   #反向解析
#address=/ipaas.sveil.com/192.168.1.101   #强制解析域名到指定的地址，但容器内所有域名会被全部绑定
#address=/.ipaas.sveil.com/192.168.1.101  #强制解析所有子域名到指定地址
systemctl restart NetworkManager dnsmasq #所有缓存都在内存里，重启服务即清空
systemctl status NetworkManager dnsmasq | grep Active -B3
nslookup www.ipaas.sveil.com 192.168.1.101
netstat -ltnp
```

## 8. 安装openshift
```
#安装etcd服务
yum install etcd
systemctl start etcd.service
systemctl enable etcd.service
#安装master服务
yum install origin-master-1.4.1-1.el7.x86_64 \
            origin-pod-1.4.1-1.el7.x86_64 \
            origin-sdn-ovs-1.4.1-1.el7.x86_64 \
            origin-dockerregistry-1.4.1-1.el7.x86_64
#安装node服务
#yum install origin-node-1.4.1-1.el7.x86_64 \
             origin-pod-1.4.1-1.el7.x86_64 \
             origin-sdn-ovs-1.4.1-1.el7.x86_64 \
             origin-dockerregistry-1.4.1-1.el7.x86_64
vi /etc/origin/master/master-config.yaml
29   masterPublicURL: https://www.ipaas.sveil.com:8443
31   publicURL: https://www.ipaas.sveil.com:8443/console/
55   - kubernetes
56   - kubernetes.default
57   - kubernetes.default.svc
58   - kubernetes.default.svc.cluster.local
59   - localhost
60   - openshift
61   - openshift.default
62   - openshift.default.svc
63   - openshift.default.svc.cluster.local
64   - sveil.com
65   - ipaas.sveil.com
66   - 127.0.0.1
67   - 172.17.0.1
68   - 172.30.0.1
69   - 192.168.1.101
70   - 192.168.1.101:8443
99   storageDirectory: /var/lib/origin/openshift.local.etcd
139  schedulerConfigFile: /etc/origin/master/scheduler.json
156  masterPublicURL: https://www.ipaas.sveil.com:8443
162  networkPluginName: redhat/openshift-ovs-multitenant
166  assetPublicURL: https://www.ipaas.sveil.com:8443/console/
177  kind: HTPasswdPasswordIdentityProvider
178  file: /etc/origin/master/htpasswd
180  masterPublicURL: https://www.ipaas.sveil.com:8443
208  subdomain: ipaas.sveil.com
htpasswd -c -b /etc/origin/master/htpasswd richard 123456
htpasswd -b /etc/origin/master/htpasswd dev dev123456
vi /etc/origin/master/scheduler.json
{
    "apiVersion": "v1",
    "kind": "Policy",
    "predicates": [
        {
            "name": "MatchNodeSelector"
        },
        {
            "name": "PodFitsResources"
        },
        {
            "name": "PodFitsPorts"
        },
        {
            "name": "NoDiskConflict"
        },
        {
            "name": "NoVolumeZoneConflict"
        },
        {
            "name": "MaxEBSVolumeCount"
        },
        {
            "name": "MaxGCEPDVolumeCount"
        },
        {
            "argument": {
                "serviceAffinity": {
                    "labels": [
                        "region"
                    ]
                }
            },
            "name": "Region"
        }
    ],
    "priorities": [
        {
            "name": "LeastRequestedPriority",
            "weight": 1
        },
        {
            "name": "SelectorSpreadPriority",
            "weight": 1
        },
        {
            "argument": {
                "serviceAntiAffinity": {
                    "label": "zone"
                }
            },
            "name": "Zone",
            "weight": 2
        }
    ]
}
systemctl enable origin-master.service
systemctl start origin-master.service
mkdir .kube
ln -s /etc/origin/master/admin.kubeconfig .kube/config
chmod +r /etc/origin/master/admin.kubeconfig
chmod +r /etc/origin/master/openshift-registry.kubeconfig
chmod +r /etc/origin/master/openshift-router.kubeconfig
vi ~/.bash_profile
11   export OPENSHIFT_HOME=/var/lib/origin/
12   export KUBECONFIG=/etc/origin/master/admin.kubeconfig
13   export CURL_CA_BUNDLE=/etc/origin/master/ca.crt
14   export MASTER_CONFIG_DIR=/etc/origin/master/
source ~/.bash_profile
cd /var/lib/origin/
ln -s /etc/origin/ openshift.local.config
mkdir /etc/origin/node0.ipaas.sveil.com
oadm create-node-config --node-dir='/etc/origin/node0.ipaas.sveil.com/' \
      --dns-domain='dns.ipaas.sveil.com' \
      --dns-ip='192.168.1.101' \
      --hostnames=node0.ipaas.sveil.com,192.168.1.101 \
      --master='https://192.168.1.101:8443' \
      --network-plugin='redhat/openshift-ovs-multitenant' \
      --node='node0.ipaas.sveil.com'
scp /etc/origin/node0.ipaas.sveil.com/* root@192.168.1.101:/etc/origin/node/
vi /etc/origin/node/node-config.yaml
18   kubeletArguments:
19   node-labels:
20   - region=primary
21   - zone=west
31   nodeIP: 192.168.1.101
systemctl start origin-node.service
systemctl enable origin-node.service
systemctl stop origin-master.service origin-node.service
docker pull openshift/origin-pod:v1.4.1
docker pull openshift/origin-docker-registry:v1.4.1
docker pull openshift/origin-deployer:v1.4.1
docker pull openshift/origin-haproxy-router:v1.4.1
docker pull openshift/origin-sti-builder:v1.4.1
docker pull openshift/origin:v1.4.1
docker pull openshift/origin-logging-deployer:v1.4.1
docker pull openshift/origin-metrics-cassandra:v1.4.1
docker pull openshift/origin-metrics-deployer:v1.4.1
docker pull openshift/origin-metrics-hawkular-metrics:v1.4.1
docker pull openshift/origin-metrics-heapster:v1.4.1
docker pull openshift/origin-sti-builder:v1.4.1
docker pull cockpit/kubernetes:latest
systemctl start origin-master.service origin-node.service
oc login -u system:admin -n default
#如果删除~/.bash_profile，将不能使用system:admin登录，把环境变量加上就可以了。
oc whoami
oc status -v
#安装docker registry配置使用PVC
#oc login -u system:admin -n default
mkdir -p /mnt/data/openshift-storage/origin-docker-registry/docker
chown 1001:root /mnt/data/openshift-storage/origin-docker-registry
chown 1000020000:1000020000 /mnt/data/openshift-storage/origin-docker-registry/docker
chmod g+s -R /mnt/data/openshift-storage/origin-docker-registry
vi ./yaml/registry-storage-list.yaml
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    creationTimestamp: null
    labels:
      project: default
      provider: docker-registry
    name: default-registry-pv
  spec:
    accessModes:
    - ReadWriteMany
    capacity:
      storage: 100Gi
    claimRef:
      kind: PersistentVolumeClaim
      name: default-registry-data
      namespace: default
    hostPath:
      path: /mnt/data/openshift-storage/origin-docker-registry
    persistentVolumeReclaimPolicy: Recycle
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    creationTimestamp: null
    labels:
      project: default
      provider: docker-registry
    name: default-registry-data
  spec:
    accessModes:
    - ReadWriteMany
    resources:
      requests:
        storage: 100Gi
    volumeName: default-registry-pv
oc create -f ./yaml/registry-pvc.yaml
oadm policy add-scc-to-user privileged system:serviceaccount:default:registry
oadm registry --service-account=registry
oc set volume dc/docker-registry --add --name=registry-storage \
   --type=persistentVolumeClaim --claim-name=default-registry-data --overwrite
oc get serviceaccount |grep registry
oc get clusterrolebinding |grep registry-registry-role
oc get all
oc get svc
oc get rc
oc get pod
#修改registry为固定ip 172.30.0.3
oc get svc docker-registry -o yaml > ./yaml/registry-svc.yaml
oc delete -f ./yaml/registry-svc.yaml
vi ./yaml/registry-svc.yaml
13   clusterIP: 172.30.0.3
oc create -f ./yaml/registry-svc.yaml
#账户授权
oadm policy add-role-to-user system:registry richard
oadm policy add-role-to-user admin richard -n openshift
oadm policy add-role-to-user admin richard -n default
oadm policy add-role-to-user system:image-builder richard
#创建registry的路由和证书
mkdir /var/lib/origin/secrets
oc project default
oc create route passthrough --service docker-registry -n default
oadm ca create-server-cert \
    --signer-cert=/etc/origin/master/ca.crt \
    --signer-key=/etc/origin/master/ca.key \
    --signer-serial=/etc/origin/master/ca.serial.txt \
    --hostnames='docker-registry-default.ipaas.sveil.com,172.30.0.3' \
    --cert=/var/lib/origin/secrets/registry.crt \
    --key=/var/lib/origin/secrets/registry.key
oc secrets new registry-secret \
    /var/lib/origin/secrets/registry.crt \
    /var/lib/origin/secrets/registry.key
oc secrets add serviceaccounts/registry secrets/registry-secret
oc secrets add serviceaccounts/default  secrets/registry-secret
oc set volume dc/docker-registry --add --type=secret \
    --secret-name=registry-secret -m /etc/secrets
oc describe dc/docker-registry
oc set env dc/docker-registry \
    REGISTRY_HTTP_TLS_CERTIFICATE=/etc/secrets/registry.crt \
    REGISTRY_HTTP_TLS_KEY=/etc/secrets/registry.key \
  -n default
oc patch dc/docker-registry -p '{"spec": {"template": {"spec": {"containers":[{
    "name":"registry",
    "livenessProbe":  {"httpGet": {"scheme":"HTTPS"}}
  }]}}}}' -n default
oc patch dc/docker-registry -p '{"spec": {"template": {"spec": {"containers":[{
    "name":"registry",
    "readinessProbe":  {"httpGet": {"scheme":"HTTPS"}}
  }]}}}}' -n default
#查看日志
journalctl -f -u origin-node.service |grep kube_docker_client.go
tail -f /var/log/messages |grep origin-node
#删除环境变量
#oc set env dc/docker-registry REGISTRY_HTTP_TLS_CERTIFICATE- REGISTRY_HTTP_TLS_KEY-
#在master上创建route服务
oadm policy add-scc-to-user hostnetwork system:serviceaccount:default:router
oadm policy add-cluster-role-to-user cluster-reader system:serviceaccount:default:router
oadm router --replicas=0 --service-account=router
#允许子域名
oc set env dc/router ROUTER_ALLOW_WILDCARD_ROUTES=true
oc scale dc/router --replicas=1
#查看证书存放路径
oc describe dc/router
#oc describe dc/router |grep ROUTER_ALLOW_WILDCARD_ROUTES
#创建sveil.com的公钥和私钥
mkdir ~/certificate && cd ~/certificate
cat > san.cnf << EOF
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = req_distinguished_name
req_extensions     = req_ext
[ req_distinguished_name ]
C            = CN
ST           = Shanghai
L            = Shanghai
O            = sveil
OU           = SVEIL.COM
emailAddress = support@sveil.com
CN           = sveil.com
[ req_ext ]
subjectAltName = @alt_names
[alt_names]
DNS.1 = sveil.com
DNS.2 = ipaas.sveil.com
DNS.3 = master0.sveil.com
DNS.4 = *.sveil.com
DNS.5 = *.ipaas.sveil.com
DNS.6 = *.master0.ipaas.sveil.com
IP.1  = 192.168.1.101
IP.2  = 127.0.0.1
EOF
openssl req -out sveil.com.csr -newkey rsa:2048 -nodes -keyout sveil.com.key -config san.cnf
#签发证书
openssl x509 -req -days 366 -in sveil.com.csr -signkey sveil.com.key \
   -out sveil.com.crt -extensions req_ext -extfile san.cnf
cp ~/certificate/sveil.com.crt /etc/origin/master/
cp ~/certificate/sveil.com.key /etc/origin/master/
#OpenShift Web Console的证书包含在/etc/origin/master/master.server.crt，查看可以通过
openssl x509 -in /etc/origin/master/master.server.crt -noout -text
#重新生成Console证书
service_names="kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,localhost,openshift,openshift.default,openshift.default.svc,openshift.default.svc.cluster.local,sveil.com,ipaas.sveil.com"
service_ip="192.168.1.101,127.0.0.1,172.17.0.1,172.30.0.1"
oadm ca create-master-certs --cert-dir=./master \
          --master=https://www.ipaas.sveil.com:8443 \
          --public-master=https://www.ipaas.sveil.com:8443 \
          --hostnames=master0.ipaas.sveil.com,$service_ip,$service_names \
          --overwrite=false
cp ./master/master.server.crt /etc/origin/master/
cp ./master/master.server.key /etc/origin/master/
#修改配置
vi /etc/origin/master/master-config.yaml
38     maxRequestsInFlight: 0
39     namedCertificates:
40     - certFile: sveil.com.crt
41       keyFile: sveil.com.key
42       names:
43       - "*.sveil.com"
44     requestTimeoutSeconds: 0
227    maxRequestsInFlight: 500
228    namedCertificates:
229    - certFile: sveil.com.crt
230      keyFile: sveil.com.key
231      names:
232      - "*.sveil.com"
233    requestTimeoutSeconds: 3600
systemctl restart origin-master.service origin-node.service

#安装registry-console
git clone https://github.com/openshift/openshift-ansible
cd ~/openshift-ansible/roles/openshift_hosted_templates/files/v1.4/origin/
oc create -n default -f registry-console.yaml
oc create route passthrough --service registry-console \
    --port registry-console \
    -n default
oc new-app -n default --template=registry-console \
    -p OPENSHIFT_OAUTH_PROVIDER_URL="https://www.ipaas.sveil.com:8443" \
    -p REGISTRY_HOST=$(oc get route docker-registry -n default --template='{{ .spec.host }}') \
    -p COCKPIT_KUBE_URL=$(oc get route registry-console -n default --template='https://{{ .spec.host }}')
#登录到docker-registry
oc login -u richard
docker login -u richard -p $(oc whoami -t) 172.30.0.3:5000
docker tag openshift/origin-pod:v1.4.1 172.30.0.3:5000/default/origin-pod:v1.4.1
docker push 172.30.0.3:5000/default/origin-pod:v1.4.1
docker tag openshift/origin-docker-registry:v1.4.1 172.30.0.3:5000/default/origin-docker-registry:v1.4.1
docker push 172.30.0.3:5000/default/origin-docker-registry:v1.4.1
docker tag openshift/origin-deployer:v1.4.1 172.30.0.3:5000/default/origin-deployer:v1.4.1
docker push 172.30.0.3:5000/default/origin-deployer:v1.4.1
#创建is和templates
cd ~/openshift-ansible/roles/openshift_examples/files/examples/v1.4/
for f in image-streams/image-streams-centos7.json; do cat $f | oc create -n openshift -f -; done
for f in db-templates/*.json; do cat $f | oc create -n openshift -f -; done
for f in quickstart-templates/*.json; do cat $f | oc create -n openshift -f -; done
#创建项目
oc new-project base --display-name="Base Installation"
oc new-project cicd --display-name="CI/CD"
oc new-project dev --display-name="Tasks - Dev"
oc new-project product --display-name="Product Online"
oc new-project test --display-name="Tasks - Test"
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n dev
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n test
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n product
```

## 9. 准备安装cicd前提条件
```
#用richard用户登录docker-registry
oc login -u richard -n cicd
docker login -u richard -p $(oc whoami -t) 172.30.0.3:5000
#下载必需的工具镜像
docker pull gogs/gogs:0.11.4
docker pull centos/postgresql-95-centos7
docker pull openshift/jenkins-2-centos7
docker pull sonatype/nexus:2.14.4
docker pull sonarqube:6.3.1
docker pull marvambass/subversion
docker pull registry.access.redhat.com/jboss-eap-7/eap70-openshift:1.4-34
docker pull centos/mysql-57-centos7
#把下载的镜像打上tag
docker tag docker.io/gogs/gogs:0.11.4 172.30.0.3:5000/openshift/gogs:0.11.4
docker tag docker.io/centos/postgresql-95-centos7:latest 172.30.0.3:5000/openshift/postgresql-95-centos7:latest
docker tag docker.io/openshift/jenkins-2-centos7:latest 172.30.0.3:5000/openshift/jenkins-2-centos7:latest
docker tag docker.io/sonatype/nexus:2.14.4 172.30.0.3:5000/openshift/nexus:2.14.4
docker tag docker.io/sonarqube:6.3.1 172.30.0.3:5000/openshift/sonarqube:6.3.1
docker tag docker.io/marvambass/subversion:latest 172.30.0.3:5000/openshift/subversion:latest
docker tag registry.access.redhat.com/jboss-eap-7/eap70-openshift:1.4-34 172.30.0.3:5000/openshift/jboss-eap70-openshift:1.4-34
docker tag docker.io/centos/mysql-57-centos7:latest 172.30.0.3:5000/openshift/mysql-57-centos7:latest
#把打上tag的镜像上传docker-registry
docker push 172.30.0.3:5000/openshift/gogs:0.11.4
docker push 172.30.0.3:5000/openshift/postgresql-95-centos7:latest
docker push 172.30.0.3:5000/openshift/jenkins-2-centos7:latest
docker push 172.30.0.3:5000/openshift/nexus:2.14.4
docker push 172.30.0.3:5000/openshift/sonarqube:6.3.1
docker push 172.30.0.3:5000/openshift/subversion:latest
docker push 172.30.0.3:5000/openshift/jboss-eap70-openshift:1.4-34
docker push 172.30.0.3:5000/openshift/mysql-57-centos7:latest
#创建容器挂载的硬盘目录空间及权限
mkdir -p /mnt/data/base-storage/activemq
mkdir -p /mnt/data/base-storage/memcache
mkdir -p /mnt/data/base-storage/redis
mkdir -p /mnt/data/base-storage/solor
mkdir -p /mnt/data/cicd-storage/gogs-postgresql
mkdir -p /mnt/data/cicd-storage/gogs
mkdir -p /mnt/data/cicd-storage/jenkins
mkdir -p /mnt/data/cicd-storage/nexus
mkdir -p /mnt/data/cicd-storage/sonarqube-postgresql
mkdir -p /mnt/data/cicd-storage/sonarqube
mkdir -p /mnt/data/cicd-storage/subversion
mkdir -p /mnt/data/dev-storage/zk-finance-mysql
mkdir -p /mnt/data/dev-storage/zk-finance2-mysql
mkdir -p /mnt/data/dev-storage/zk-finance-nginx
mkdir -p /mnt/data/dev-storage/zk-finance2-nginx
mkdir -p /mnt/data/product-storage/zk-finance-mysql
mkdir -p /mnt/data/product-storage/zk-finance2-mysql
mkdir -p /mnt/data/product-storage/zk-finance-nginx
mkdir -p /mnt/data/product-storage/zk-finance2-nginx
mkdir -p /mnt/data/product-storage/destoon-mysql
mkdir -p /mnt/data/product-storage/destoon
mkdir -p /mnt/data/product-storage/zentaopms-mysql
mkdir -p /mnt/data/product-storage/zentaopms
mkdir -p /mnt/data/test-storage/zk-finance-mysql
mkdir -p /mnt/data/test-storage/zk-finance2-mysql
mkdir -p /mnt/data/test-storage/zk-finance-nginx
mkdir -p /mnt/data/test-storage/zk-finance2-nginx
chown -R 26:26 /mnt/data/postgresql-storage/cicd
chown -R 1000070000:1000070000 /mnt/data/gogs-storage/cicd
chown -R 1000070000:1000070000 /mnt/data/nexus-storage/cicd
#创建服务账户cicduser无限制权限
#oc create serviceaccount cicduser
#oadm policy add-scc-to-user anyuid system:serviceaccount:cicd:default
oadm policy add-scc-to-user privileged system:serviceaccount:cicd:default
oadm policy add-scc-to-user privileged system:serviceaccount:cicd:jenkins
oadm policy add-scc-to-user privileged system:serviceaccount:dev:default
oadm policy add-scc-to-user privileged system:serviceaccount:test:default
oadm policy add-scc-to-user privileged system:serviceaccount:product:default
#查看最高权限
#oc describe scc/privileged |grep Users
#删除权限
#oadm policy remove-scc-from-user anyuid system:serviceaccount:cicd:cicduser
#读取当前用户的权限
oc get policybindings
oc describe policybindings/:default
#容器间短域名由dnsmasq解析
#用系统管理员登录
oc login -u system:admin -n cicd
```

## 10. 安装cicd
```
#查看当前用户，确保是system:admin
oc whoami
#执行cicd模板批量安装所有资源
wget https://raw.githubusercontent.com/boy12371/openshift-cicd/master/yaml/cicd-persistent-template.yaml \
     -O cicd-persistent-template.yaml
oc process -f cicd-persistent-template.yaml |oc create -f -
#删除cicd
#oc delete dc,svc,route -l app=gogs -n cicd
#oc delete dc,svc,route -l app=jenkins -n cicd
#oc delete dc,svc,route -l app=nexus -n cicd
#oc delete dc,svc,route -l app=sonarqube -n cicd
oc delete all -l app=gogs -n cicd
oc delete all -l app=jenkins -n cicd
oc delete all -l app=nexus -n cicd
oc delete all -l app=sonarqube -n cicd
oc delete all -l app=subversion -n cicd
oc delete serviceaccount/jenkins
oc delete rolebinding/jenkins_edit
oc delete rolebinding/default_edit
oc delete bc/yuantianfu-pipeline
oc delete bc/zk-finance-pipeline
oc delete bc/zk-finance2-pipeline
oc delete pv/cicd-gogs-pv
oc delete pv/cicd-gogs-postgresql-pv
oc delete pv/cicd-jenkins-pv
oc delete pv/cicd-nexus-pv
oc delete pv/cicd-sonarqube-home-pv
oc delete pv/cicd-sonarqube-data-pv
oc delete pv/cicd-sonarqube-postgresql-pv
oc delete pv/cicd-subversion-dav-svn-pv
oc delete pv/cicd-subversion-local-svn-pv
oc delete pv/cicd-subversion-svn-backup-pv
oc delete pvc/gogs-data
oc delete pvc/gogs-postgresql-data
oc delete pvc/jenkins-data
oc delete pvc/nexus-data
oc delete pvc/sonarqube-home
oc delete pvc/sonarqube-data
oc delete pvc/sonarqube-postgresql-data
oc delete pvc/subversion-dav-svn
oc delete pvc/subversion-local-svn
oc delete pvc/subversion-svn-backup
#sleep 8
rm -rf /mnt/data/cicd-storage/gogs/.[!.]*
rm -rf /mnt/data/cicd-storage/gogs/*
rm -rf /mnt/data/cicd-storage/gogs-postgresql/.[!.]*
rm -rf /mnt/data/cicd-storage/gogs-postgresql/*
rm -rf /mnt/data/cicd-storage/jenkins/.[!.]*
rm -rf /mnt/data/cicd-storage/jenkins/*
rm -rf /mnt/data/cicd-storage/nexus/.[!.]*
rm -rf /mnt/data/cicd-storage/nexus/*
rm -rf /mnt/data/cicd-storage/sonarqube-postgresql/.[!.]*
rm -rf /mnt/data/cicd-storage/sonarqube-postgresql/*
chown -R 26:26 /mnt/data/cicd-storage/gogs-postgresql
chown -R 1001:1001 /mnt/data/cicd-storage/jenkins
chown -R 200:200 /mnt/data/cicd-storage/nexus
chown -R 26:26 /mnt/data/cicd-storage/sonarqube-postgresql
oc delete events --all -n cicd
#oc delete project/cicd
#oc new-project cicd --display-name="CI/CD"
```

## 11. 安装gogs
```
#查看当前用户，确保是system:admin
oc whoami
#一键安装的方法，直接执行一键安装脚本
wget https://raw.githubusercontent.com/boy12371/openshift-cicd/master/yaml/cicd-gogs-persistent-template.yaml \
     -O cicd-gogs-persistent-template.yaml
oc process -f cicd-gogs-persistent-template.yaml |oc create -f -
#手工安装的方法
#查看账户权限oc describe scc/anyuid
#oc create serviceaccount gogs
#oc edit scc anyuid
#users:
#- system:serviceaccount:cicd:gogsvcacct
#oadm policy add-scc-to-user anyuid system:serviceaccount:cicd:gogs
oc login -u system:admin -n cicd
vi ./yaml/gogs-1.yaml
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: gogs-1
    labels:
      provider: gogs-storage
      project: cicd
  spec:
    capacity:
      storage: 50Gi
    accessModes:
    - ReadWriteMany
    hostPath:
      path: /mnt/data/gogs-storage
    persistentVolumeReclaimPolicy: Recycle
    claimRef:
      name: gogs-1
      namespace: cicd
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    labels:
      provider: gogs-storage
      project: cicd
    name: gogs-1
  spec:
    accessModes:
    - ReadWriteMany
    resources:
      requests:
        storage: 50Gi
    volumeName: gogs-1
mkdir /mnt/data/gogs-storage
chown -R 1000070000:1000070000 /mnt/data/gogs-storage
oc create -f ./yaml/gogs-1.yaml
oc login -u richard -n cicd
oc get pvc
oc set volume dc/gogs --add --name=gogs-1 \
   --type=persistentVolumeClaim --claim-name=gogs-1 --overwrite
oc set probe dc/gogs \
        --liveness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        -- echo ok
oc set probe dc/gogs \
        --readiness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        --get-url=http://:3000
oc expose svc/gogs
#首次打开url:https://gogs-cicd.master0.ipaas.sveil.com，自动跳转安装。
#新建仓库zk-finance
echo 123456 |git svn clone --username user http://svn/projects/branches/zk-finance
cd zk-finance && echo '# zk-finance' > README.md
echo -e ".settings\n.classpath\n.project\ntarget" > .gitignore
rm -rf .settings .classpath .project target
git config user.name 'gogs' && git config user.email 'gogs@cn.com' && git config http.sslVerify false
git add . && git commit -m "first commit"
git remote add origin https://gogs-cicd.master0.ipaas.sveil.com/gogs/zk-finance.git
echo 'gogs' |git push -u origin master
#删除gogs
oc delete dc,svc,route -l app=gogs -n cicd
oc delete dc,svc -l app=postgresql-gogs -n cicd
oc delete serviceaccount/cicduser
oc delete rolebinding/cicduser_edit
oc delete pv/cicd-gogs-pv
oc delete pv/cicd-postgresql-gogs-pv
oc delete pvc/gogs-data
oc delete pvc/postgresql-gogs-data
#sleep 8
oc delete events --all
rm -rf /mnt/data/gogs-storage/cicd/*
rm -rf /mnt/data/postgresql-storage/cicd/gogs/*
chown -R 26:26 /mnt/data/postgresql-storage/cicd/gogs
```

## 12. 安装jenkins
```
#查看当前用户，确保是system:admin
oc whoami
#一键安装的方法，直接执行一键安装脚本
wget https://raw.githubusercontent.com/boy12371/openshift-cicd/master/yaml/cicd-jenkins-persistent-template.yaml \
     -O cicd-jenkins-persistent-template.yaml
oc process -f cicd-jenkins-persistent-template.yaml |oc create -f -
#手工安装jenkins
mkdir -p /mnt/data/jenkins-storage/cicd
chown -R 1000070000:1000070000 /mnt/data/jenkins-storage/cicd
#同步jenkins容器内文件到挂载空间目录下
oc rsync $(oc get pod |grep jenkins |tail -n 1 |cut -d " " -f 1):/var/lib/jenkins/ /mnt/data/jenkins-storage/cicd/
oc set volume dc/jenkins --add --name=jenkins-data \
   --type=persistentVolumeClaim --claim-name=jenkins-data \
   --overwrite
oc set env dc/jenkins \
    TZ=Asia/Shanghai \
  -n cicd
#安装后继续安装或更新插件Safe Restart Plugin / Maven Integration plugin / Pipeline Maven Integration Plugin
#Task Scanner Plug-in / Subversion Plug-in
#下载https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.zip
#下载http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
#cd /mnt/data/jenkins-storage/cicd && unzip ~/apache-maven-3.5.0-bin.zip && tar -zxvf ~/jdk-8u131-linux-x64.tar.gz
#"Manage Jenkins" => "Global Tool Configuration" => "JDK 安装" => "JDK别名: JDK8"; "JAVA_HOME: /var/lib/jenkins/jdk1.8.0_131"
#"Maven 安装" => "Maven Name: M3_HOME"; "MAVEN_HOME: /var/lib/jenkins/apache-maven-3.5.0"
#在Credentials添加svn / gogs / nexus的账户和密码，生成用于Pipeline的credentialsId
#"Manage Jenkins" => "Managed files"（如果没有找到，那么没有正确安装Maven Integration plugin） => "Add a new Config"
#选择"Global Maven settings.xml" => 填写configuration/settings.xml
#如果在jenkins终端看不到test,那么再执行一次
oc policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n test
oc policy add-role-to-group system:image-puller system:serviceaccounts:test -n dev
#把imagePullPolicy：从 IfNotPresent 改为 Always，这样防止从缓存读镜像。
#准备zk-finance项目
wget https://raw.githubusercontent.com/boy12371/openshift-cicd/master/yaml/dev-zk-finance-list.yaml \
     -O dev-zk-finance-list.yaml
oc create -f dev-zk-finance-list.yaml
#删除jenkins
oc delete dc,svc,route -l app=jenkins -n cicd
#oc delete all -l app=jenkins -n cicd
oc delete serviceaccount/jenkins
oc delete rolebinding/jenkins_edit
oc delete bc/jboss-pipeline
oc delete bc/nginx-pipeline
oc delete pv/cicd-jenkins-pv
oc delete pvc/jenkins-data
oc delete events --all
rm -rf /mnt/data/jenkins-storage/cicd/*
rm -rf /mnt/data/jenkins-storage/cicd/.cache
rm -rf /mnt/data/jenkins-storage/cicd/.groovy
rm -rf /mnt/data/jenkins-storage/cicd/.java
rm -rf /mnt/data/jenkins-storage/cicd/.kube
chown -R 1000070000:1000070000 /mnt/data/jenkins-storage/cicd
```

## 13. 安装nexus
```
#查看当前用户，确保是system:admin
oc whoami
#一键安装的方法，直接执行一键安装脚本
wget https://raw.githubusercontent.com/boy12371/openshift-cicd/master/yaml/cicd-nexus-persistent-template.yaml \
     -O cicd-nexus-persistent-template.yaml
oc process -f cicd-nexus-persistent-template.yaml |oc create -f -
#手工安装nexus
oc expose svc/nexus
oc set probe dc/nexus \
        --liveness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        --get-url=http://:8081/content/groups/public
oc set probe dc/nexus \
        --readiness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        --get-url=http://:8081/content/groups/public
oc login -u system:admin -n cicd
vi ./yaml/nexus-1.yaml
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: nexus-1
    labels:
      provider: nexus-storage
      project: cicd
  spec:
    capacity:
      storage: 5Gi
    accessModes:
    - ReadWriteMany
    hostPath:
      path: /mnt/data/nexus-storage
    persistentVolumeReclaimPolicy: Recycle
    claimRef:
      name: nexus-1
      namespace: cicd
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    labels:
      provider: nexus-storage
      project: cicd
    name: nexus-1
  spec:
    accessModes:
    - ReadWriteMany
    resources:
      requests:
        storage: 5Gi
    volumeName: nexus-1
mkdir /mnt/data/nexus-storage
chown -R 1000070000:1000070000 /mnt/data/nexus-storage
oc create -f ./yaml/nexus-1.yaml
oc login -u richard -n cicd
oc get pvc
oc set volume dc/nexus --add --name=nexus-data \
   --type=persistentVolumeClaim --claim-name=nexus-data --overwrite
#默认nexus的超级管理员口令admin/admin123
#删除nexus
oc delete dc,svc,route -l app=nexus -n cicd
oc delete serviceaccount/cicduser
oc delete rolebinding/cicduser_edit
oc delete pv/cicd-nexus-pv
oc delete pvc/nexus-data
oc delete events --all
rm -rf /mnt/data/nexus-storage/cicd/*
chown -R 200:200 /mnt/data/nexus-storage/cicd
```

## 14. 安装sonarqube
```
#查看当前用户，确保是system:admin
oc whoami
#一键安装的方法，直接执行一键安装脚本
wget https://raw.githubusercontent.com/boy12371/openshift-cicd/master/yaml/cicd-sonarqube-persistent-template.yaml \
     -O cicd-sonarqube-persistent-template.yaml
oc process -f cicd-sonarqube-persistent-template.yaml |oc create -f -
#手工安装的方法
mkdir -p /mnt/data/sonarqube-storage/cicd
chown -R 1000070000:1000070000 /mnt/data/sonarqube-storage/cicd
#同步sonarqube容器内文件到挂载空间目录下
oc rsync $(oc get pod |grep sonarqube |tail -n 1 |cut -d " " -f 1):/opt/sonarqube/ /mnt/data/sonarqube-storage/cicd/
oc set volume dc/sonarqube --add --name=sonarqube-home \
   --type=persistentVolumeClaim --claim-name=sonarqube-home \
   --mount-path=/opt/sonarqube
oc set volume dc/sonarqube --add --name=sonarqube-data \
   --type=persistentVolumeClaim --claim-name=sonarqube-data \
   --mount-path=/opt/sonarqube/data
#查看当前项目状态
oc status -v
#默认sonarqube的超级管理员口令admin/admin
#删除sonarqube
oc delete dc,svc,route -l app=sonarqube -n cicd
oc delete dc,svc -l app=postgresql-sonarqube -n cicd
oc delete serviceaccount/cicduser
oc delete rolebinding/cicduser_edit
oc delete pv/cicd-sonarqube-home-pv
oc delete pv/cicd-sonarqube-data-pv
oc delete pv/cicd-postgresql-sonarqube-pv
oc delete pvc/sonarqube-home
oc delete pvc/sonarqube-data
oc delete pvc/postgresql-sonarqube-data
#sleep 8
oc delete events --all
rm -rf /mnt/data/sonarqube-storage/cicd/data/*
rm -rf /mnt/data/postgresql-storage/cicd/sonarqube/*
chown -R 26:26 /mnt/data/postgresql-storage/cicd/sonarqube
```

## 15. 创建Pipeline
wget
oc create -f pipeline-template.yaml -n cicd
oc process -f simple-pipeline -p PIPELINE-NAME=nginx
#删除pipeline
oc delete pipeline/nginx
oc delete template/simple-pipeline

## 16. 安装subversion
```
#下载subversion
docker pull marvambass/subversion
docker tag docker.io/marvambass/subversion:latest 172.30.0.3:5000/openshift/subversion:latest
docker push 172.30.0.3:5000/openshift/subversion:latest
#添加root用户权限
oadm policy add-scc-to-user anyuid -n subversion -z default
#添加可写硬盘空间
mkdir -p /mnt/data/subversion-storage/subversion-1
mkdir /mnt/data/subversion-storage/subversion-2
mkdir /mnt/data/subversion-storage/subversion-3
mkdir /mnt/data/subversion-storage/subversion-4
chown -R 1000130000:1000130000 /mnt/data/subversion-storage
oc set volume dc/subversion --add --name=subversion-1 \
   --type=persistentVolumeClaim --claim-name=subversion-1 \
   --overwrite
oc set volume dc/subversion --add --name=subversion-2 \
   --type=persistentVolumeClaim --claim-name=subversion-2 \
   --overwrite
oc set volume dc/subversion --add --name=subversion-3 \
   --type=persistentVolumeClaim --claim-name=subversion-3 \
   --overwrite
oc set volume dc/subversion --add --mount-path=/etc/apache2 \
   --name=subversion-4 --type=persistentVolumeClaim \
   --claim-name=subversion-4
oc expose svc/subversion
oc set probe dc/subversion \
        --liveness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        -- echo ok
oc set probe dc/subversion \
        --readiness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        --get-url=http://:80
htpasswd -bc /mnt/data/subversion-storage/subversion-4/dav_svn/dav_svn.passwd richard 123456
htpasswd -b /mnt/data/subversion-storage/subversion-4/dav_svn/dav_svn.passwd test test
```

## 17. 安装禅道8.3.1
```
mkdir -p /mnt/data/mysql-storage/zentaopms
chown -R 1000120000:1000120000 /mnt/data/mysql-storage/zentaopms
mkdir -p /mnt/data/php-storage/zentaopms
oc set volume dc/zentao8 --add --mount-path=/opt/app-root/src \
   --name=zentao-php --type=persistentVolumeClaim \
   --claim-name=
oc set probe dc/zentao8 \
        --liveness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        -- echo ok
oc set probe dc/zentao8 \
        --readiness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        --get-url=http://:8080
```

## 18. 安装nginx
```
oc login -u system:admin
oadm policy add-scc-to-user anyuid -n dev -z default
docker pull nginx:1.13
docker tag docker.io/nginx:1.13 172.30.0.3:5000/openshift/nginx:1.13
oc login -u richard -n default
docker login -u richard -p $(oc whoami -t) 172.30.0.3:5000
docker push 172.30.0.3:5000/openshift/nginx:1.13
oc new-app --docker-image=172.30.0.3:5000/openshift/nginx:1.13 --name=nginx
mkdir -p /mnt/data/nginx-storage/dev/conf/
oc rsync $(oc get pod |grep nginx |cut -d " " -f 1):/etc/nginx/ /mnt/data/nginx-storage/dev/conf/
oc set volume dc/nginx --add --name=nginx-conf --type=persistentVolumeClaim \
   --claim-name=nginxconf-dev-pvc --mount-path=/etc/nginx
oc set volume dc/nginx --add --name=nginx-html --type=persistentVolumeClaim \
   --claim-name=nginxhtml-dev-pvc --mount-path=/usr/share/nginx/html
oc set probe dc/nginx \
        --liveness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        -- echo ok
oc set probe dc/nginx \
        --readiness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        --get-url=http://:80
oc expose svc/nginx
#新增普通用户sftp
useradd -m -U -c 'SFTP User' sftpus
passwd sftpus
chown -R sftpus:sftpus /mnt/data/nginx-storage/dev/html
su sftpus
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''
ssh-copy-id sftpus@nginx-dev.master0.ipaas.sveil.com
ssh sftpus@nginx-dev.master0.ipaas.sveil.com
#拷贝出id_rsa
#限制用户通过sftp登录进来时只能进入主目录
vi /etc/ssh/sshd_config
146 #Subsystem      sftp    /usr/libexec/openssh/sftp-server
147 Subsystem       sftp    internal-sftp
148 Match User sftpus
149 ChrootDirectory /mnt/data/nginx-storage/dev
150 X11Forwarding no
151 AllowTcpForwarding no
152 ForceCommand internal-sftp
#登录sftp
sftp -P 22 -i /Users/wangzhang/Documents/kuangjia.org/amazon_keys/nginx_sftp sftpus@192.168.1.101
```

## 19. 安装odoo
```
oc login -u system:admin
oadm policy add-scc-to-user anyuid -n test -z default
docker pull odoo:10.0
docker tag docker.io/odoo:10.0 172.30.0.3:5000/openshift/odoo:10.0
```

## 20. 安装destoon
```
oc rsync $(oc get pod |grep destoon |tail -n 1 |cut -d " " -f 1):/opt/app-root/src/ /mnt/data/php-storage/destoon/
mkdir /mnt/data/mysql-storage/destoon
chown -R 1000080000:1000080000 /mnt/data/mysql-storage/destoon
mkdir /mnt/data/php-storage/destoon
chown -R 1000080000:1000080000 /mnt/data/php-storage/destoon
oc set volume dc/destoon --add --mount-path=/opt/app-root/src \
   --name=destoon-data --type=persistentVolumeClaim \
   --claim-name=destoon-data
oc set volume dc/mysql --add --name=mysql-data \
   --type=persistentVolumeClaim --claim-name=mysql-data \
   --overwrite
oc set probe dc/destoon \
        --liveness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        -- echo ok
oc set probe dc/destoon \
        --readiness \
        --failure-threshold 3 \
        --initial-delay-seconds 30 \
        --get-url=http://:8080
```

* Grafana：图像监控系统
* Kibana：日志系统
* Prometheus：监控数据存储

### 参考：
```
https://wiki.centos.org/zh/SpecialInterestGroup/PaaS/OpenShift-Quickstart
#Centos7安装openshift Origin 1.3.0集群
https://seanzhau.com/blog/post/seanzhau/1e12392b0d5f
#openshift配置docker registry
https://seanzhau.com/blog/post/seanzhau/a6ecbecfdeba
http://www.pangxie.space/docker/964
http://www.pangxie.space/docker/989
http://www.yunweipai.com/archives/8664.html
#Openshift origin multi-node installation guide
https://www.shaunos.com/721.html
#OpenShift_049：Master 节点是如何调度 Node 节点的？
http://maping930883.blogspot.com/2017/01/openshift049master-node.html
#OpenShift-红帽Docker容器管理平台
http://sanwen.net/a/bicqepo.html
#Registry Overview
https://docs.openshift.org/latest/install_config/registry/deploy_registry_existing_clusters.html
#Certificates
https://github.com/openshift/origin/issues/4225
http://guifreelife.com/blog/2016/03/24/Replace-OpenShift-Console-SSL-Certificate
https://docs.openshift.org/latest/install_config/certificate_customization.html
https://docs.openshift.org/latest/install_config/router/default_haproxy_router.html#using-wildcard-certificates
https://docs.openshift.org/latest/install_config/upgrading/automated_upgrades.html
#pipeline
http://maping930883.blogspot.com/2017/03/openshift061-jenkins-pipeline-project.html
#jboss-eap-7
https://blog.openshift.com/building-microservices-jboss-eap-7-netflix-oss-openshift/
```
