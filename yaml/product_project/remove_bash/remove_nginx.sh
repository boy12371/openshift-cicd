#!/bin/bash
#
oc delete all -l app=nginx -n product
#oc delete rolebinding/default_edit -n product
oc delete pv/product-nginx-conf-pv
oc delete pvc/nginx-conf -n product
oc delete pv/product-nginx-html-pv
oc delete pvc/nginx-html -n product
oc delete events --all -n product
