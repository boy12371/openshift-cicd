#!/bin/bash
#
oc project $PROJECT3
oc get all -l app=route-http -n $PROJECT3
oc delete all -l app=route-http -n $PROJECT3
