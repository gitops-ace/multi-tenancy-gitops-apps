#!/usr/bin/env bash

# Set variables
IBM_REST_DBPARMS_PATH=/Users/khongks/Documents/Dev/gitops-ace/multi-tenancy-gitops-apps/ace/environments/base/secrets
SEALEDSECRET_NAMESPACE=sealed-secrets

# cat file ibm-rest-dbparms.txt
#mqsisetdbparms -w /home/aceuser/ace-server -n setdbparms::truststore -u "truststorepwd" -p passw0rd
#mqsisetdbparms -w /home/aceuser/ace-server -n setdbparms::keystore -u "keystorepwd" -p passw0rd
#mqsisetdbparms -w /home/aceuser/ace-server -n local::basicAuthOverride -u aceuser -p changeit


# Create Kubernetes Secret yaml
oc create secret generic ibm-rest-dbparms.txt \
--from-file=configuration=${IBM_REST_DBPARMS_PATH}/ibm-rest-dbparms.txt \
--type Opaque \
--dry-run=client -o yaml > delete-ibm-rest-dbparms-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal --scope cluster-wide --controller-name=sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-ibm-rest-dbparms-secret.yaml > ibm-rest-dbparms-secret.yaml

# NOTE, do not check delete-*-secret.yaml into git!
rm delete-ibm-rest-dbparms-secret.yaml
