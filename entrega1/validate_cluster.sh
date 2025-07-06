#!/usr/bin/env bash

set -e

# Lista de Pods esperados
EXPECTED_PODS=("users_app" "offers_app" "posts_app" "routes_app" "users_db" "offers_db" "posts_db" "routes_db")

# Mapa de servicios esperados y su Pod target
declare -A EXPECTED_SERVICES
EXPECTED_SERVICES=( 
    ["users_service"]="users_app"
    ["offers_service"]="offers_app"
    ["posts_service"]="posts_app"
    ["routes_service"]="routes_app"
)

TOTAL_PODS=${#EXPECTED_PODS[@]}
FOUND_PODS=0

echo "✅ Checking expected pods..."
for POD in "${EXPECTED_PODS[@]}"; do
    if kubectl get pods | grep -q "$POD"; then
        echo "✔️ $POD found"
        FOUND_PODS=$((FOUND_PODS+1))
    else
        echo "❌ $POD NOT found"
    fi
done

PODS_PERCENT=$(( 100 * FOUND_PODS / TOTAL_PODS ))
echo "Pods found: $FOUND_PODS/$TOTAL_PODS -> ${PODS_PERCENT}%"

if [ $FOUND_PODS -lt $TOTAL_PODS ]; then
    echo "❌ Not all expected pods are running."
    exit 1
fi

echo ""
echo "✅ Checking expected services and their targets..."
TOTAL_SERVICES=${#EXPECTED_SERVICES[@]}
FOUND_SERVICES=0

for SERVICE in "${!EXPECTED_SERVICES[@]}"; do
    TARGET_POD=${EXPECTED_SERVICES[$SERVICE]}
    # Check if service exists
    if kubectl get svc | grep -q "$SERVICE"; then
        echo "✔️ $SERVICE exists"
        
        # Get the selector (assuming 'app' label is used)
        SELECTOR=$(kubectl get svc "$SERVICE" -o jsonpath='{.spec.selector.app}')
        
        if [ "$SELECTOR" == "$TARGET_POD" ]; then
            echo "✔️ $SERVICE points to $TARGET_POD"
            FOUND_SERVICES=$((FOUND_SERVICES+1))
        else
            echo "❌ $SERVICE does not point to $TARGET_POD (found selector: $SELECTOR)"
        fi
    else
        echo "❌ Service $SERVICE NOT found"
    fi
done

SERVICES_PERCENT=$(( 100 * FOUND_SERVICES / TOTAL_SERVICES ))
echo "Services correctly configured: $FOUND_SERVICES/$TOTAL_SERVICES -> ${SERVICES_PERCENT}%"

if [ $FOUND_SERVICES -lt $TOTAL_SERVICES ]; then
    echo "❌ Some services are missing or misconfigured."
    exit 1
fi

echo "✅ All checks passed!"
exit 0