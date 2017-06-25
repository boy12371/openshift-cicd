#!/bin/bash
#
oc delete all -l app=zentao -n product
#oc delete rolebinding/default_edit -n product
oc delete pv/product-zentao-mysql-pv
oc delete pvc/zentao-mysql-data -n product
oc delete pv/product-zentao-pv
oc delete pvc/zentao-data -n product
oc delete secrets/zentao -n product
oc delete events --all -n product
