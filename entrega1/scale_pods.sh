#!/usr/bin/env bash
set -e

APPS=("users-app" "posts-app" "routes-app" "offers-app")
DBS=("users-db" "posts-db" "routes-db" "offers-db")

echo "------------------Enabling services for $NAME ------------------"
for APP in "${APPS[@]}"; do
 if kubectl get deployment "$APP-deployment" >/dev/null 2>&1; then
    kubectl scale deployment "$APP-deployment" --replicas=1
    echo "ℹ️  Enabling $APP-deployment."
  else
    echo "ℹ️  Deployment $APP-deployment ommitted."
  fi
done

for DB in "${DBS[@]}"; do
  if kubectl get deployment "$DB-deployment" >/dev/null 2>&1; then
    kubectl scale deployment "$DB-deployment" --replicas=1
  else
    echo "ℹ️  Enabling $DB-deployment."
    echo "ℹ️  Deployment $DB-deployment ommitted."
  fi
done