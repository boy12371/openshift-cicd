#!/bin/bash
#
# `eval "if [ \$PATHS$e ]; then echo path: "'$PATHS'$e"; fi"`
if [ "$(oc whoami)" != "system:admin" ]; then
  oc login -u system:admin -n $PROJECT3
elif [ "$(oc project -q)" != $PROJECT3 ]; then
  oc project $PROJECT3
fi
for((d=1;d<101;d++)); do
cat > $PROJECT3-nginx-http-route-list.yaml << EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: Route
  metadata:
    name: `eval echo '$DNSNAME'$d`
    namespace: $PROJECT3
    creationTimestamp: null
    labels:
      app: route-http
    annotations:
      description: Route for Jboss http service.
      openshift.io/host.generated: 'true'
  spec:
    host: `eval echo '$DNS'$d`
    port:
      targetPort: nginx-80-tcp
    to:
      kind: Service
      name: nginx
      weight: 100
    wildcardPolicy: None
EOF
oc create -f $PROJECT3-nginx-http-route-list.yaml
done
