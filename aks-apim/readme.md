# Terraform samples

Based on https://blog.nillsf.com/index.php/2019/10/08/using-a-api-management-in-front-of-an-azure-kubernetes-cluster/

## Creating a service principal for Terraform

```sh
# The following service principal has to be owner because it will assign roles to other service principals
az ad sp create-for-rbac --name brainboard-poc --role Owner --scopes /subscriptions/5aca58de-08b6-4477-b736-1af925fa1624
```

## Setting the environment variables

```sh
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```

## Considering an existing storage account for Terraform state, run the following commands to get the key and set the environment variable:

```sh

```shell
ACCOUNT_KEY=$(az storage account keys list --resource-group rg-terraform-state --account-name brainboardpoc0001 --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY
```