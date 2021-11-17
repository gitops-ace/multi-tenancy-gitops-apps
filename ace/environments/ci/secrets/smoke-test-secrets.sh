#!/usr/bin/env bash

# Set variables
KEYSTOREPASSWORD=passw0rd
CERT_PATH=/Users/khongks/Documents/Dev/gitops-ace/ace-rest-ws/certs/
SEALEDSECRET_NAMESPACE=sealed-secrets

# Create Kubernetes Secret yaml
oc create secret generic ibm-client.jks \
--from-literal=keyStorePassword=${KEYSTOREPASSWORD} \
--from-file=keyStore=${CERT_PATH}/ibm-client.jks \
--type Opaque \
--dry-run=client -o yaml > delete-ibm-client-jks-secret.yaml 

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal --scope cluster-wide --controller-name=sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-ibm-client-jks-secret.yaml > ibm-client-jks-secret.yaml

# NOTE, do not check delete-*-secret.yaml into git!
rm delete-ibm-client-jks-secret.yaml