#!/bin/bash
#
oc delete all -l app=gogs -n cicd
#oc delete rolebinding/default_edit -n cicd
oc delete pv/cicd-gogs-postgresql-pv
oc delete pvc/zentao-mysql-data -n product
oc delete pv/product-zentao-pv
oc delete pvc/zentao-data -n product
oc delete secrets/zentao -n product
oc delete events --all -n product
