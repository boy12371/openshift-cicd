#!/bin/bash
#
if [ "$(oc whoami)" != "system:admin" ]; then
  oc login -u system:admin -n $PROJECT3
fi
for ((c=1;c<101;c++)); do
  echo '$DNNSNAME'$c=`eval echo '$DNNSNAME'$c`
  echo '$PROJ'$c=`eval echo '$PROJ'$c`
  oc delete route/`eval echo '$DNNSNAME'$c` -n `eval echo '$PROJ'$c`
done
