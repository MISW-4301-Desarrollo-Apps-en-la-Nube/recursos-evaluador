#!/usr/bin/env bash

set -e

# Lista de Pods esperados
EXPECTED_PODS=("users-app" "offers-app" "posts-app" "routes-app" "users-db" "offers-db" "posts-db" "routes-db")

# Mapa de servicios esperados y su Pod target
declare -A EXPECTED_SERVICES
EXPECTED_SERVICES=( 
    ["users-app-service"]="users-app"
    ["offers-app-service"]="offers-app"
    ["posts-app-service"]="posts-app"
    ["routes-app-service"]="routes-app"
    ["users-db-service"]="users-db"
    ["offers-db-service"]="offers-db"
    ["posts-db-service"]="posts-db"
    ["routes-db-service"]="routes-db"
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

TOTAL_FOUND=$(( FOUND_PODS + FOUND_SERVICES ))
TOTAL_COMPONENTS=$(( TOTAL_PODS + TOTAL_SERVICES ))

COMPONENTS_PERCENT=$(( TOTAL_FOUND / TOTAL_COMPONENTS * 100 ))
echo "Components correctly configured: ${COMPONENTS_PERCENT}%"

if [ $TOTAL_FOUND -lt $TOTAL_COMPONENTS ]; then
    echo "❌ Not all components are correctly configured."
    exit 1
fi

echo "✅ All checks passed!"
exit 0