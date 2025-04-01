# osmedeus
osmedeus

```
az account list -o table && read -p "Enter Subscription ID or Name: " sub && az account set --subscription "$sub" && read -p "Enter Resource Group: " rg && curl -o main.bicep https://raw.githubusercontent.com/DataGuys/osmedeus/refs/heads/main/main.bicep && az deployment group create --resource-group "$rg" --template-file main.bicep

```



