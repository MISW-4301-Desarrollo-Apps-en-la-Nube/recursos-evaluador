#!/bin/bash

#Inputs
APP_NAME=$1
QUANTITY=$2

DEPLOYMENT_NAME=$(kubectl get deployment -l app="$APP_NAME" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
if [ -n "$DEPLOYMENT_NAME" ]; then
  echo "ℹ️ Scaling $DEPLOYMENT_NAME to $QUANTITY replicas."
  kubectl scale deployment $DEPLOYMENT_NAME --replicas=$QUANTITY -n default
else
  echo "ℹ️ Deployment for $APP_NAME omitted."
fi
