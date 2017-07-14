#!/bin/bash
#
. "./dns-variable.sh" "zhonglele.com"
if [ "$(oc whoami)" != "system:admin" ]; then
  oc login -u system:admin -n $PROJECT3
fi
oc delete route -l app=route-http -n $PROJECT3
for ((c=1;c<40;c++)); do
  oc delete route/`eval echo '$DNNSNAME'$c` -n `eval echo '$PROJ'$c`
done
