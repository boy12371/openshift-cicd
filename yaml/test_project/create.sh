#!/bin/bash
#
projectName=test
if [ "$(oc whoami)" != "system:admin" ]; then
  echo "Please create these apps by user system:admin."
  exit 0
elif [ "$(oc project -q)" != $projectName ]; then
  echo "Please using project $projectName create these apps."
  exit 0
fi
oc create -f $projectName-list.yaml -n $projectName
oc create -f $projectName-zk-finance2-list.yaml -n $projectName
