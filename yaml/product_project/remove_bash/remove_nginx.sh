#!/bin/bash
#
oc delete all -l app=nginx -n product
#oc delete rolebinding/default_edit -n product
oc delete pv/product-nginx-pv
oc delete pvc/nginx-data -n product
oc delete events --all -n product
