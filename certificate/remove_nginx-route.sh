#!/bin/bash
#
oc project $PROJECT3
oc get route -l app=route-http -n $PROJECT3
oc delete route -l app=route-http -n $PROJECT3
