#!/bin/bash
#
#`eval "if [ \$PATHS$e ]; then echo path: "'$PATHS'$e"; fi"`
for((e=1;e<101;e++)); do
cat > `eval echo '$DNNSNAME'$e`-list.yaml << EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: Route
  metadata:
    name: `eval echo '$DNNSNAME'$e`
    namespace: `eval echo '$PROJ'$e`
    creationTimestamp: null
    labels:
      app: route-https
    annotations:
      description: Route for Jboss http service.
      openshift.io/host.generated: 'true'
  spec:
    host: `eval echo '$DNNS'$e`
    port:
      targetPort: `eval echo '$TARGET'$e`
    to:
      kind: Service
      name: `eval echo '$SERVICE'$e`
      weight: 100
    wildcardPolicy: None
EOF
oc delete route/`eval echo '$DNNSNAME'$e` -n $PROJECT3
oc project `eval echo '$PROJ'$e`
oc delete route/`eval echo '$DNNSNAME'$e` -n `eval echo '$PROJ'$e`
oc create -f `eval echo '$DNNSNAME'$e`-list.yaml -n `eval echo '$PROJ'$e`
done
