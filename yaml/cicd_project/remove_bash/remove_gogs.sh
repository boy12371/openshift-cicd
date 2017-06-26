#!/bin/bash
#
oc delete all -l app=gogs -n cicd
# oc delete rolebinding/default_edit -n cicd
# oc delete pv/cicd-gogs-postgresql-pv
# oc delete pvc/gogs-postgresql-data -n cicd
# oc delete pv/cicd-gogs-pv
# oc delete pvc/gogs-data -n cicd
oc delete events --all -n cicd
