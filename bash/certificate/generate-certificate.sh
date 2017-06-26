#!/bin/bash
#
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
# 签发证书
openssl x509 -req -days 366 -in sveil.com.csr -signkey sveil.com.key \
   -out sveil.com.crt -extensions req_ext -extfile san.cnf
openssl req -out sveil.com.csr -newkey rsa:2048 -nodes -keyout sveil.com.key -config san.cnf
openssl x509 -req -days 366 -in sveil.com.csr -signkey sveil.com.key \
   -out sveil.com.crt -extensions req_ext -extfile san.cnf
