```sh
# The following service principal has to be owner because it will assign roles to other service principals
az ad sp create-for-rbac --name brainboard-poc --role Owner --scopes /subscriptions/5aca58de-08b6-4477-b736-1af925fa1624
```