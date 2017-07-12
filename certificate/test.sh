#!/bin/bash
#
. "./dns-variable.sh" "zhonglele.com"
for ((b=1;b<99;b++)); do
  DNS_SAN=$DNS_SAN"DNS.$b = `eval echo '$DNS'$b`\n"
done
cat > san.cnf << EOF
"if [ \$PATHS$e ]; then echo path: "'$PATHS'$e"; fi"
EOF
