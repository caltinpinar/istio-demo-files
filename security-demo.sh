#!/bin/bash

########################
# include the magic
########################
export DEMO_MAGIC_PATH=/root/demo-magic/demo-magic.sh
. ${DEMO_MAGIC_PATH}

# make demo output look pretty
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# hide the evidence
clear

# run through examples

#create istio-demo namespace
pei "export KUBECONFIG=/root/ocp-hub/install_dir/auth/kubeconfig"
pe "oc new-project istio-demo"

#example deployments

#frontend
pei "echo Frontend deployment"
pe "cat security/web-frontend.yaml"

pe "oc create -f security/web-frontend.yaml -n istio-demo"

pe "oc get pods -n istio-demo"

#customer backend
pei "echo Customer Backend v1 deployment"
pe "cat security/customers-v1.yaml"

pe "oc create -f security/customers-v1.yaml -n istio-demo"

pe "oc get pods -n istio-demo"

#Create basics for access frontend
pei "echo Creating Gateway"
pe "oc create -f security/gateway.yaml -n istio-demo"

pe "oc get gateways -n istio-demo"

pe "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"

pei "echo DenyAll"
pe "cat security/deny-all.yaml"
pe "oc create -f security/deny-all.yaml -n istio-demo"

pe "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/"

pei "echo Allow ingress"
pe "cat security/allow-ingress-frontend.yaml"
pe "oc create -f security/allow-ingress-frontend.yaml -n istio-demo"

pe "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/"


pei "echo Allow frontend to customer"
pe "cat security/allow-web-frontend-customers.yaml"
pe "oc create -f security/allow-web-frontend-customers.yaml -n istio-demo"

pe "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"


pei "echo 'End of security Scnarios'"
