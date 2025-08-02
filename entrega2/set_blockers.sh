#!/bin/bash

#Inputs
APP_NAME=$1
BLOCKER_FILE=$2

# Default values
DEFAULT_NAMESPACE="ingress-nginx"
DEFAULT_NAME="ingress-nginx"


echo "🔍 Looking for ingress in namespace '$DEFAULT_NAMESPACE' with name '$DEFAULT_NAME'"

# Check if the Ingress Controller exists in the default namespace
if kubectl get pod -n "$DEFAULT_NAMESPACE" | grep -q "$DEFAULT_NAME"; then
  export INGRESS_NAMESPACE=$DEFAULT_NAMESPACE
  export INGRESS_APP=$DEFAULT_NAME
  echo "INGRESS_NAMESPACE=$DEFAULT_NAMESPACE" >> $GITHUB_ENV
  echo "INGRESS_APP=$DEFAULT_NAME" >> $GITHUB_ENV
  echo "✅ Ingress Controller found: $DEFAULT_NAMESPACE in namespace $DEFAULT_NAME"
else
  echo "⚠️ Ingress was not found in namespace. Searching in all the namespaces..."

  # Seach pod with label app.kubernetes.io/name=ingress-nginx
  POD_INFO=$(kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{range .items[0]}{.metadata.namespace} {.metadata.labels.app\.kubernetes\.io/name}{end}')

  if [ -n "$POD_INFO" ]; then
    export INGRESS_NAMESPACE=$(echo "$POD_INFO" | awk '{print $1}')
    export INGRESS_APP=$(echo "$POD_INFO" | awk '{print $2}')
    echo "INGRESS_NAMESPACE=$INGRESS_NAMESPACE" >> $GITHUB_ENV
    echo "INGRESS_APP=$INGRESS_APP" >> $GITHUB_ENV
    echo "✅ Ingress Controller found:"
    echo "   Namespace: $INGRESS_NAMESPACE"
    echo "   Label (app.kubernetes.io/name): $INGRESS_APP"
  else
    echo "❌ Ingress was not found with label 'app.kubernetes.io/name=ingress-nginx'"
    exit 1
  fi
fi

export BLOCK_APP=$APP_NAME
envsubst < $BLOCKER_FILE | kubectl apply -f -