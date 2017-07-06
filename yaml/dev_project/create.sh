#!/bin/bash
#
projectName=dev
appName1=zk-qualification
appName2=cas-sso-server
if [ "$(oc whoami)" != "system:admin" ]; then
  echo "Please create these apps by user system:admin."
  exit 0
elif [ "$(oc project -q)" != $projectName ]; then
  echo "Please using project $projectName create these apps."
  exit 0
fi
# oc create -f $projectName-$appName1-list.yaml -n $projectName
# oc create -f $projectName-$appName2-list.yaml -n $projectName
oc process -f $projectName-global-template.yaml |oc create -f - -n $projectName
