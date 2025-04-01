#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Bash script to build and deploy the osmedeus Docker image on Azure
# with a simple interactive subscription selector
# -----------------------------------------------------------------------------

# Exit if any command fails
set -e

echo "Retrieving all available subscriptions..."
# Using --query to get a simplified list: Name, Subscription ID
subscriptions=$(az account list --query '[].{Name:name, ID:id}' -o tsv 2>/dev/null)

if [[ -z "$subscriptions" ]]; then
  echo "No subscriptions found or not logged in. Please log in via 'az login' first."
  exit 1
fi

# Store subscriptions in arrays for easy access
declare -a subNames
declare -a subIDs
count=0

while IFS=$'\t' read -r name id; do
    subNames[$count]="$name"
    subIDs[$count]="$id"
    ((count++))
done <<< "$subscriptions"

# Display a menu of subscriptions
echo "Select a subscription from the list below:"
for i in "${!subNames[@]}"; do
    echo "$((i+1)). ${subNames[$i]} (${subIDs[$i]})"
done

read -p "Enter the number of the subscription to use: " selection

# Check for valid input
if ! [[ "$selection" =~ ^[0-9]+$ ]] || (( selection < 1 || selection > count )); then
    echo "Invalid selection. Exiting..."
    exit 1
fi

index=$((selection-1))
selectedSubscriptionId="${subIDs[$index]}"

echo "Setting active subscription to ID: $selectedSubscriptionId"
az account set --subscription "$selectedSubscriptionId"

# -----------------------------------------------------------------------------
# Proceed with resource creation and container setup
# Adjust resource group and ACR details as necessary
# -----------------------------------------------------------------------------

RESOURCE_GROUP="osmedeus-rg"
LOCATION="eastus"
ACR_NAME="osmedeusregistry"
CONTAINER_NAME="osmedeus-container"

echo "Creating resource group '$RESOURCE_GROUP' in '$LOCATION'..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

echo "Creating Azure Container Registry '$ACR_NAME'..."
az acr create --resource-group "$RESOURCE_GROUP" --name "$ACR_NAME" --sku Basic

echo "Building the image directly in ACR using ACR Tasks..."
az acr build --registry "$ACR_NAME" --image osmedeus:latest https://github.com/osmedeus/osmedeus-base.git

echo "Enabling admin account on ACR..."
az acr update --name "$ACR_NAME" --admin-enabled true

echo "Retrieving registry credentials..."
ACR_USERNAME=$(az acr credential show --name "$ACR_NAME" --query "username" -o tsv)
ACR_PASSWORD=$(az acr credential show --name "$ACR_NAME" --query "passwords[0].value" -o tsv)

echo "Creating the container instance '$CONTAINER_NAME'..."
az container create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CONTAINER_NAME" \
  --image "${ACR_NAME}.azurecr.io/osmedeus:latest" \
  --cpu 2 \
  --memory 4 \
  --registry-login-server "${ACR_NAME}.azurecr.io" \
  --registry-username "$ACR_USERNAME" \
  --registry-password "$ACR_PASSWORD" \
  --ports 8000 \
  --dns-name-label osmedeus-app

echo "Deployment complete!"
