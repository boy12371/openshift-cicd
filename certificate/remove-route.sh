#!/bin/bash
#
if [ "$(oc whoami)" != "system:admin" ]; then
  oc login -u system:admin -n $PROJECT3
fi
for ((c=1;c<101;c++)); do
  oc delete route/`eval echo '$DNNSNAME'$c` -n `eval echo '$PROJ'$c`
done
