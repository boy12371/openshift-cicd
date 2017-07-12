#!/bin/bash
#
for ((c=1;c<6;c++)); do
  oc get route -l app=route-https -n `eval echo '$PROJECT'$c`
  oc delete route -l app=route-https -n `eval echo '$PROJECT'$c`
done
