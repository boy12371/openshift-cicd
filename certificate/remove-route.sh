#!/bin/bash
#
# . "./dns-variable.sh" "zhonglele.com"
if [ "$(oc whoami)" != "system:admin" ]; then
  oc login -u system:admin -n $PROJECT3
fi
for((a=1;a<6;a++)); do
  oc delete route -l app=route-http -n `eval echo '$PROJECT'$a`
done
