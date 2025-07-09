#!/usr/bin/env bash
set -e

echo "------------------Enabling services------------------"

ENV_VARS=()

SERVICES=("users-app-service" "posts-app-service")

for SERVICE in "${SERVICES[@]}"; do
  if kubectl get svc "$SERVICE" >/dev/null 2>&1; then
    SELECTOR=$(kubectl get svc "$SERVICE" -o jsonpath='{.spec.selector.app}')
    echo "Waiting for pods with selector app=$SELECTOR (from $SERVICE)..."
    kubectl wait --for=condition=ready pod -l app="$SELECTOR" --timeout=120s
    URL=$(minikube service "$SERVICE" --url)

    SERVICE_NAME=$(echo "$SERVICE" | cut -d'-' -f1 | tr '[:lower:]' '[:upper:]')
    ENV_VARS+=(--env-var "${SERVICE_NAME}_PATH=$URL")
  else
    echo "❌ Service $SERVICE not found, skipping..."
  fi
done

echo "------------------Execute tests------------------"

if [ ${#ENV_VARS[@]} -gt 0 ]; then
  echo "🚀 Running Newman..."
  newman run ".evaluator/entrega1.json" "${ENV_VARS[@]}" --verbose
else
  echo "❌ No valid services found for Newman run. Exiting."
fi