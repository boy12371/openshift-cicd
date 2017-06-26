#!/bin/bash
#
if $(oc whoami) -ne system:admin; then
  echo "Create these apps by user system:admin."
  exit 0
else if $(oc project -q) -ne cicd; then
  echo "Using project cicd create these apps."
  exit 0
else
  oc process -f cicd-global-template.yaml |oc create -f -
  oc process -f cicd-gogs-persistent-template.yaml |oc create -f -
# oc process -f cicd-nexus-persistent-template.yaml |oc create -f -
# oc process -f cicd-subversion-persistent-template.yaml |oc create -f -
# oc process -f cicd-sonarqube-persistent-template.yaml |oc create -f -
fi
