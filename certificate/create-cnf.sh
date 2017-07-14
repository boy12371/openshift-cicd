#!/bin/bash
#
DNS_SAN=''
for ((b=1;b<51;b++)); do
  DNS_SAN=$DNS_SAN"DNS.$b = `eval echo '$DNS'$b`\n"
done
cat > $CNF << EOF
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
O            = ${1%.*}
OU           = `echo $1 |tr '[:lower:]' '[:upper:]'`
emailAddress = support@$1
CN           = $1
[ req_ext ]
subjectAltName = @alt_names
[alt_names]
`echo -e $DNS_SAN`
IP.1  = 210.51.26.187
IP.2  = 127.0.0.1
EOF
