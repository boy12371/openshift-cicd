#!/bin/bash
#
DOMAIN1='zhonglele.com'
DOMAIN2='yuantianfu.cn'
DOMAIN3='yuantianfu.net'
DOMAIN4='yuantianfu.com'

for ((i=1;i<5;i++)); do
  DOMAIN=`eval echo '$DOMAIN'$i`
  . "./dns-variable.sh" $DOMAIN
  . "./create-cnf.sh" $DOMAIN
  ACCOUNTKEY='account.key'
  DOMAINKEY=$DOMAIN'.key'
  CSR=$DOMAIN'.csr'
  SIGN_CRT=$DOMAIN'.crt'
  if [ ! -f "$ACCOUNTKEY" ]; then
    openssl genrsa 4096 > $ACCOUNTKEY
  fi
  if [ ! -f "$DOMAINKEY" ]; then
    openssl genrsa 4096 > $DOMAINKEY
  fi
  if [ ! -f "$CSR" ]; then
    # openssl req -out $CSR -newkey rsa:4096 -nodes -keyout $DOMAINKEY -config $CNF
    # openssl x509 -req -days 366 -in $CSR -signkey $DOMAINKEY -out $UNSIGN_CRT -extensions req_ext -extfile $CNF
    openssl req -new -sha256 -key $DOMAINKEY -config $CNF -out $CSR
    openssl req -text -noout -in $CSR
  # cp ~/certificate/zhonglele.com.crt /etc/origin/master/
  # cp ~/certificate/$DOMAINKEY /etc/origin/master/
  # wget https://raw.githubusercontent.com/boy12371/acme-tiny/master/acme_tiny.py
  fi

  . "./remove-route.sh"
  . "./install-nginx-route.sh"

  if [ ! -f "$SIGN_CRT" ]; then
    python acme_tiny.py --account-key ./$ACCOUNTKEY --csr ./$CSR --acme-dir $ACME_DIR > ./$SIGN_CRT || exit
  fi

  . "./remove-nginx-route.sh"
  . "./install-route.sh"
done
