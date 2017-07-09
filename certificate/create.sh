#!/bin/bash
#
KEY='zhonglele.com.key'
if [ ! -f $KEY ]; then
openssl req -out zhonglele.com.csr -newkey rsa:2048 -nodes -keyout zhonglele.com.key -config san.cnf
openssl x509 -req -days 366 -in zhonglele.com.csr -signkey zhonglele.com.key \
  -out zhonglele.com.unsigned.crt -extensions req_ext -extfile san.cnf
# cp ~/certificate/zhonglele.com.crt /etc/origin/master/
# cp ~/certificate/zhonglele.com.key /etc/origin/master/
# wget https://raw.githubusercontent.com/boy12371/acme-tiny/master/acme_tiny.py
python acme_tiny.py --account-key ./zhonglele.com.key --csr ./zhonglele.com.csr --acme-dir \
  /mnt/data/product-storage/nginx/html/.well-known/acme-challenge/ > ./zhonglele.com.signed.crt
