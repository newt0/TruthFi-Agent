#!/bin/bash

# TruthFi Production Deployment Script

echo "=== TruthFi Production Deployment ==="
echo "⚠️  WARNING: This will deploy to PRODUCTION environment"
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Deployment cancelled"
    exit 0
fi

echo "Starting production environment deployment..."

cd "../src"

# Check if required files exist
if [ ! -f "truthfi-core-prod.lua" ]; then
    echo "Error: truthfi-core-prod.lua not found"
    exit 1
fi

# Check if production wallet exists
if [ ! -f "$PROD_WALLET_PATH" ]; then
    echo "Error: Production wallet not found at $PROD_WALLET_PATH"
    echo "Please set PROD_WALLET_PATH environment variable"
    exit 1
fi

# Start production process
echo "Launching AOS with production configuration..."
echo "Using wallet: $PROD_WALLET_PATH"
aos --wallet "$PROD_WALLET_PATH" --load truthfi-core-prod.lua --name "TruthFi-Production"

echo "🚀 Production deployment completed!"
echo "⚠️  IMPORTANT: Record the Process ID for frontend integration"
echo "⚠️  IMPORTANT: Update monitoring systems with new Process ID"