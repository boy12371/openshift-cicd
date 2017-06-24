#!/bin/bash
#
oc delete all -l app=jenkins -n cicd
oc delete serviceaccount/jenkins -n cicd
oc delete rolebinding/jenkins_edit -n cicd
#oc delete svc/jenkins -n cicd
#oc delete svc/jenkins-jnlp -n cicd
#oc delete dc/jenkins -n cicd
oc delete pvc/jenkins-data -n cicd
oc delete pv/cicd-jenkins-pv
#oc delete routes/jenkins-http
#oc delete routes/jenkins -n cicd
oc delete events --all -n cicd
