#!/bin/bash
#
oc process -f cicd-global-template.yaml |oc create -f -
oc process -f cicd-gogs-persistent-template.yaml |oc create -f -
oc process -f cicd-nexus-persistent-template.yaml |oc create -f -
oc process -f cicd-subversion-persistent-template.yaml |oc create -f -
oc process -f cicd-sonarqube-persistent-template.yaml |oc create -f -
