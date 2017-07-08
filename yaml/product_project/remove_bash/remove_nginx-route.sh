#!/bin/bash
#
oc get all -l app=nginx-http -n product
oc delete all -l app=nginx-http -n product
