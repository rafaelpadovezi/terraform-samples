```sh
az ad sp create-for-rbac --name brainboard-poc --role Contributor --scopes /subscriptions/5aca58de-08b6-4477-b736-1af925fa1624
```

```sh
az role assignment create --assignee "900f89d2-f497-4e34-9af1-2f47bee439e0" \ # client-id
    --role "Contributor" \
    --scope "/subscriptions/5aca58de-08b6-4477-b736-1af925fa1624/resourceGroups/blog-apim-and-aks/providers/Microsoft.Network/virtualNetworks/apim-aks-vnet/subnets/aks-subnet"
```
