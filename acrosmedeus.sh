# List all available subscriptions
az account list --output table

#set the active subscription by ID
az account set --subscription "your-subscription-id"

# Create a resource group or pick one already created
az group create --name osmedeus-rg --location eastus

# Create an Azure Container Registry change out the resource group name to one you already created if so.
az acr create --resource-group osmedeus-rg --name osmedeusregistry --sku Basic

# Build the image directly in ACR using ACR Tasks
az acr build --registry osmedeusregistry --image osmedeus:latest https://github.com/osmedeus/osmedeus-base.git
