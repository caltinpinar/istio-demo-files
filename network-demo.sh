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
pe "cat network/deployment-web-frontend.yaml"

pe "oc create -f network/deployment-web-frontend.yaml -n istio-demo"

pe "oc get pods -n istio-demo"

#customer backend
pei "echo Customer Backend v1 deployment"
pe "cat network/deployment-customers-v1.yaml"

pe "oc create -f network/deployment-customers-v1.yaml -n istio-demo"

pei "echo Customer Backend v2 deployment"
pe "cat network/deployment-customers-v2.yaml"

pe "oc create -f network/deployment-customers-v2.yaml -n istio-demo"

pe "oc get pods -n istio-demo"

#Create basics for access frontend
pei "echo Creating Gateway"
pe "oc create -f network/gateway.yaml -n istio-demo"

pe "oc get gateways -n istio-demo"

pei "echo Virtual Service"
pe "oc create -f network/web-frontend-vs.yaml -n istio-demo"

pe "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"

pei "echo Destionation Rule"
pe "cat network/customers-dr.yaml"
pe "oc create -f network/customers-dr.yaml -n istio-demo"

pei "echo 'Case1 50-50 traffic spliting'"
pe "cat network/customers-vs-50-50.yaml"
pe "oc create -f network/customers-vs-50-50.yaml -n istio-demo"

pei "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"
pei "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"
pei "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"
pei "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"
pei "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"

pei "echo 'Case2 Header based routing'"
pe "cat network/customers-vs-headers.yaml"
pe "oc replace -f network/customers-vs-headers.yaml -n istio-demo"

pe "curl -si http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"
pe "curl -si -H 'user: debug' http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"

pei "echo 'Case3 Custom Delay'"
pe "cat network/customers-vs-delay.yaml"
pe "oc replace -f network/customers-vs-delay.yaml -n istio-demo"

pei "curl http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"
pei "curl http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"
pei "curl http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"
pei "curl http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"
pei "curl http://istio-ingressgateway-istio-system.apps.hub.swo.local/ | grep -E 'CITY|NAME'"


pei "echo 'Case4 Fault Injection'"
pe "cat network/customers-vs-fault.yaml"
pe "oc replace -f network/customers-vs-fault.yaml -n istio-demo"

pei "curl -s -o /dev/null -I -w '%{http_code}' http://istio-ingressgateway-istio-system.apps.hub.swo.local/ "
pei "curl -s -o /dev/null -I -w '%{http_code}' http://istio-ingressgateway-istio-system.apps.hub.swo.local/ "
pei "curl -s -o /dev/null -I -w '%{http_code}' http://istio-ingressgateway-istio-system.apps.hub.swo.local/ "
pei "curl -s -o /dev/null -I -w '%{http_code}' http://istio-ingressgateway-istio-system.apps.hub.swo.local/ "
pei "curl -s -o /dev/null -I -w '%{http_code}' http://istio-ingressgateway-istio-system.apps.hub.swo.local/ "


pei "echo 'End of Network Scnarios'"
