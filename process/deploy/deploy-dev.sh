#!/bin/bash

# TruthFi Development Deployment Script

echo "=== TruthFi Development Deployment ==="
echo "Starting development environment deployment..."

cd "../src"

# Check if required files exist
if [ ! -f "truthfi-core-dev.lua" ]; then
    echo "Error: truthfi-core-dev.lua not found"
    exit 1
fi

# Start development process
echo "Launching AOS with development configuration..."
aos --load truthfi-core-dev.lua --name "TruthFi-Dev-$(date +%Y%m%d-%H%M%S)"

echo "Development deployment completed!"
echo "Use the displayed Process ID for frontend integration"