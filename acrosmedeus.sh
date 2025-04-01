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

# Enable admin account on ACR
az acr update --name osmedeusregistry --admin-enabled true

# Get the registry credentials
ACR_USERNAME=$(az acr credential show --name osmedeusregistry --query "username" -o tsv)
ACR_PASSWORD=$(az acr credential show --name osmedeusregistry --query "passwords[0].value" -o tsv)

# Create the container instance
az container create \
  --resource-group osmedeus-rg \
  --name osmedeus-container \
  --image osmedeusregistry.azurecr.io/osmedeus:latest \
  --cpu 2 \
  --memory 4 \
  --registry-login-server osmedeusregistry.azurecr.io \
  --registry-username $ACR_USERNAME \
  --registry-password $ACR_PASSWORD \
  --ports 8000 \
  --dns-name-label osmedeus-app
