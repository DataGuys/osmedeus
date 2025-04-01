# osmedeus
osmedeus

```
az account list -o table && read -p "Enter subscription number (starting from 1): " num && subid=$(az account list --query "[$(($num-1))].id" -o tsv) && subname=$(az account list --query "[$(($num-1))].name" -o tsv) && echo "Selected: $subname" && az account set --subscription "$subid" && read -p "Enter Resource Group: " rg && curl -o main.bicep https://raw.githubusercontent.com/DataGuys/osmedeus/refs/heads/main/main.bicep && az deployment group create --resource-group "$rg" --template-file main.bicep
```



