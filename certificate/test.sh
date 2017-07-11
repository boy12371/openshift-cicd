#!/bin/bash
#
. "./dns-variable.sh" "zhonglele.com"
for ((b=1;b<85;b++)); do
  DNS_SAN=$DNS_SAN"DNS.$b = `eval echo '$DNS'$b`\n"
done
cat > san.cnf << EOF
`echo $DNS_SAN`
EOF
