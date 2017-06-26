#!/bin/bash
#
projectName=cicd
if [ "$(oc whoami)" != "system:admin" ]; then
  echo "Please create these apps by user system:admin."
  exit 0
elif [ "$(oc project -q)" != "cicd" ]; then
  echo "Please using project cicd create these apps."
  exit 0
else
  oc process -f cicd-global-template.yaml |oc create -f - -n $projectName
  oc process -f cicd-gogs-persistent-template.yaml |oc create -f - -n $projectName
# oc process -f cicd-nexus-persistent-template.yaml |oc create -f - -n $projectName
# oc process -f cicd-subversion-persistent-template.yaml |oc create -f - -n $projectName
# oc process -f cicd-sonarqube-persistent-template.yaml |oc create -f - -n $projectName
fi
