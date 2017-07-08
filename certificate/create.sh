#!/bin/bash
#
openssl req -out zhonglele.com.csr -newkey rsa:2048 -nodes -keyout zhonglele.com.key -config san.cnf
openssl x509 -req -days 366 -in zhonglele.com.csr -signkey zhonglele.com.key \
   -out zhonglele.com.crt -extensions req_ext -extfile san.cnf
# cp ~/certificate/zhonglele.com.crt /etc/origin/master/
# cp ~/certificate/zhonglele.com.key /etc/origin/master/
