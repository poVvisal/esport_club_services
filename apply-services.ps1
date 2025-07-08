#!/usr/bin/env pwsh

# Apply Kubernetes manifests for all microservices
# This script applies deployment.yaml and service.yaml files in each service directory

Write-Host "Applying Kubernetes manifests for all microservices..." -ForegroundColor Green

# Array of service directories
$serviceDirectories = @(
    "Coach_Player_Microservice",
    "Registration_Microservice",
    "Ticket_Microservice"
)

# Function to apply manifests in a directory
function Invoke-ServiceManifests {
    param(
        [string]$ServiceDir
    )
    
    Write-Host "`nApplying manifests for $ServiceDir..." -ForegroundColor Yellow
    
    if (Test-Path $ServiceDir) {
        # Apply deployment.yaml
        $deploymentFile = Join-Path $ServiceDir "deployment.yaml"
        if (Test-Path $deploymentFile) {
            Write-Host "  Applying deployment.yaml..." -ForegroundColor Cyan
            kubectl apply -f $deploymentFile
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✓ Deployment applied successfully" -ForegroundColor Green
            } else {
                Write-Host "  ✗ Failed to apply deployment" -ForegroundColor Red
            }
        } else {
            Write-Host "  ⚠ deployment.yaml not found" -ForegroundColor Yellow
        }
        
        # Apply service.yaml
        $serviceFile = Join-Path $ServiceDir "service.yaml"
        if (Test-Path $serviceFile) {
            Write-Host "  Applying service.yaml..." -ForegroundColor Cyan
            kubectl apply -f $serviceFile
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✓ Service applied successfully" -ForegroundColor Green
            } else {
                Write-Host "  ✗ Failed to apply service" -ForegroundColor Red
            }
        } else {
            Write-Host "  ⚠ service.yaml not found" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ✗ Directory $ServiceDir not found" -ForegroundColor Red
    }
}

# Check if kubectl is available
if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    Write-Host "✗ kubectl is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Apply manifests for each service
foreach ($serviceDir in $serviceDirectories) {
    Invoke-ServiceManifests -ServiceDir $serviceDir
}

Write-Host "`nAll microservice manifests have been processed!" -ForegroundColor Green
Write-Host "Check the output above for any errors." -ForegroundColor Yellow
