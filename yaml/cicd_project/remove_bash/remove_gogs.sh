#!/bin/bash
#
projectName=cicd
if [ "$(oc whoami)" != "system:admin" ]; then
  echo "Please create these apps by user system:admin."
  exit 0
elif [ "$(oc project -q)" != "cicd" ]; then
  echo "Please using project cicd create these apps."
  exit 0
fi
oc delete all -l app=gogs -n $projectName
# oc delete rolebinding/default_edit -n cicd
oc delete pv/cicd-gogs-postgresql-pv
oc delete pvc/gogs-postgresql-data -n $projectName
oc delete pv/cicd-gogs-pv
oc delete pvc/gogs-data -n $projectName
oc delete configmap/gogs-config -n $projectName
oc delete events --all -n $projectName
