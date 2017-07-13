#!/bin/bash
#
for ((c=1;c<101;c++)); do
  oc delete route/`eval echo '$DNNS'$c` -n `eval echo '$PROJ'$c`
done
