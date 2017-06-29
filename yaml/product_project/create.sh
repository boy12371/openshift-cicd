#!/bin/bash
#
projectName=product
if [ "$(oc whoami)" != "system:admin" ]; then
  echo "Please create these apps by user system:admin."
  exit 0
elif [ "$(oc project -q)" != "product" ]; then
  echo "Please using project product create these apps."
  exit 0
fi
oc process -f product-global-template.yaml |oc create -f - -n $projectName
oc process -f product-nginx-persistent-template.yaml |oc create -f - -n $projectName
# oc process -f product-zentao-persistent-template.yaml |oc create -f - -n $projectName
