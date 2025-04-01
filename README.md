# osmedeus
osmedeus

```
read -p "Enter Resource Group: " rg && az deployment group create --resource-group "$rg" --template-uri "https://raw.githubusercontent.com/DataGuys/osmedeus/refs/heads/main/main.bicep" --parameters location=$(az group show --name "$rg" --query location -o tsv)
```


