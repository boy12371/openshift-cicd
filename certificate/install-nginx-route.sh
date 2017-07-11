#!/bin/bash
#
if [ "$(oc whoami)" != "system:admin" ]; then
  echo "Please create these apps by user system:admin."
  exit 0
elif [ "$(oc project -q)" != $PROJECT3 ]; then
  echo "Please using project $PROJECT3 create these apps."
  exit 0
fi
for((d=1;d<86;d++)); do
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
