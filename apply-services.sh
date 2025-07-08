#!/bin/bash

# Apply Kubernetes manifests for all microservices
# This script applies deployment.yaml and service.yaml files in each service directory

echo "Applying Kubernetes manifests for all microservices..."

# Array of service directories
SERVICE_DIRS=(
    "Coach_Player_Microservice"
    "Registration_Microservice"
    "Ticket_Microservice"
)

# Function to apply manifests in a directory
apply_service_manifests() {
    local service_dir=$1
    
    echo
    echo "Applying manifests for $service_dir..."
    
    if [[ -d "$service_dir" ]]; then
        # Apply deployment.yaml
        if [[ -f "$service_dir/deployment.yaml" ]]; then
            echo "  Applying deployment.yaml..."
            if kubectl apply -f "$service_dir/deployment.yaml"; then
                echo "  ✓ Deployment applied successfully"
            else
                echo "  ✗ Failed to apply deployment"
            fi
        else
            echo "  ⚠ deployment.yaml not found"
        fi
        
        # Apply service.yaml
        if [[ -f "$service_dir/service.yaml" ]]; then
            echo "  Applying service.yaml..."
            if kubectl apply -f "$service_dir/service.yaml"; then
                echo "  ✓ Service applied successfully"
            else
                echo "  ✗ Failed to apply service"
            fi
        else
            echo "  ⚠ service.yaml not found"
        fi
    else
        echo "  ✗ Directory $service_dir not found"
    fi
}

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "✗ kubectl is not installed or not in PATH"
    exit 1
fi

# Apply manifests for each service
for service_dir in "${SERVICE_DIRS[@]}"; do
    apply_service_manifests "$service_dir"
done

echo
echo "All microservice manifests have been processed!"
echo "Check the output above for any errors."
