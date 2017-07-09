#!/bin/bash
#
CNF='san.cnf'
KEY='zhonglele.com.key'
CSR='zhonglele.com.csr'
UNSIGN_CRT='zhonglele.com.unsigned.crt'
SIGN_CRT='zhonglele.com.signed.crt'
ACME_DIR='/mnt/data/product-storage/nginx/html/.well-known/acme-challenge/'
if [ ! -f "$KEY" ]; then
  openssl req -out $CSR -newkey rsa:2048 -nodes -keyout $KEY -config $CNF
  openssl x509 -req -days 366 -in $CSR -signkey $KEY -out $UNSIGN_CRT -extensions req_ext -extfile $CNF
# cp ~/certificate/zhonglele.com.crt /etc/origin/master/
# cp ~/certificate/$KEY /etc/origin/master/
# wget https://raw.githubusercontent.com/boy12371/acme-tiny/master/acme_tiny.py
elif [ ! -f "$SIGN_CRT" ]; then
  python acme_tiny.py --account-key ./$KEY --csr ./$CSR --acme-dir $ACME_DIR > ./$SIGN_CRT || exit
fi
