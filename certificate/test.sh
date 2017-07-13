#!/bin/bash
#
# `eval "if [ \$PATHS$e ]; then echo path: "'$PATHS'$e"; fi"`
. "./dns-variable.sh" "zhonglele.com"
DNS_SAN=''
for ((b=1;b<101;b++)); do
  DNS_SAN=$DNS_SAN"DNS.$b = `eval echo '$DNS'$b`\n"
done
`echo $DNS_SAN`
