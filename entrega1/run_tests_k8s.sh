#!/usr/bin/env bash
set -e

echo "------------------Enabling services------------------"

ENV_VARS=()

SERVICE="users-app-service"

if kubectl get svc "$SERVICE" >/dev/null 2>&1; then
  SELECTOR=$(kubectl get svc "$SERVICE" -o jsonpath='{.spec.selector.app}')
  echo "Waiting for pods with selector app=$SELECTOR (from $SERVICE)..."
  kubectl wait --for=condition=ready pod -l app="$SELECTOR" --timeout=60s
  URL=$(minikube service "$SERVICE" --url)
  ENV_VARS+=(--env-var "USERS_PATH=$URL")
fi

if [ ${#ENV_VARS[@]} -gt 0 ]; then
  echo "🚀 Running Newman..."
  newman run ".evaluator/entrega1.json" "${ENV_VARS[@]}" --verbose
else
  echo "❌ No valid services found for Newman run. Exiting."
fi