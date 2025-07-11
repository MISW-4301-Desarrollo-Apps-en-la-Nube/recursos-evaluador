#!/usr/bin/env bash
set -e

INPUT_NAME=$1

# Convert snake_case to kebab-case
NAME=$(echo "$INPUT_NAME" | cut -d'_' -f1)
SERVICE=$(echo "$NAME" | tr '[:lower:]' '[:upper:]')
APP_NAME="${NAME}-app"
SERVICE_NAME="${APP_NAME}-service"
DB_NAME="${NAME}-db"

APPS=("users-app" "posts-app" "routes-app" "offers-app")
DBS=("users-db" "posts-db" "routes-db" "offers-db")

echo "------------------Enabling services for ${NAME} ------------------"

# Check APP service
if kubectl get svc "$SERVICE_NAME" >/dev/null 2>&1; then
  APP_SELECTOR=$(kubectl get svc "$SERVICE_NAME" -o jsonpath='{.spec.selector.app}')
  echo "Waiting for APP pods with selector app=$APP_SELECTOR (from $SERVICE_NAME)..."
  kubectl wait --for=condition=ready pod -l app="$APP_SELECTOR" --timeout=120s
  
  APP_URL=$(minikube service "$SERVICE_NAME" --url)

  # Scale to 0 replicas for other apps and databases
  for APP in "${APPS[@]}"; do
    if [ "$APP" != "${APP_NAME}" ]; then
      if kubectl get deployment "$APP-deployment" >/dev/null 2>&1; then
        kubectl scale deployment "$APP-deployment" --replicas=0
        echo "ℹ️  Disabling $APP-deployment."
      else
        echo "ℹ️  Deployment $APP-deployment ommitted."
      fi
    fi
  done

  for DB in "${DBS[@]}"; do
    if [ "$DB" != "${DB_NAME}" ]; then
      if kubectl get deployment "$DB-deployment" >/dev/null 2>&1; then
        echo "ℹ️  Disabling $DB-deployment."
        kubectl scale deployment "$DB-deployment" --replicas=0
      else
        echo "ℹ️  Deployment $DB-deployment ommitted."
      fi
    fi
  done

  echo "------------------Execute tests------------------"
  echo "🚀 Running Newman..."
  newman run ".evaluator/entrega1_${NAME}.json" --env-var "${SERVICE}_PATH=${APP_URL}" --verbose

else
  echo "❌ Service $SERVICE_NAME not found."
  exit 1
fi