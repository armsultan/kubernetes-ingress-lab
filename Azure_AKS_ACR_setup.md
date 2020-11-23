## Azure geographies and naming convention suggestions


* Decide on a [Data center region](https://azure.microsoft.com/en-us/global-infrastructure/geographies/(https://azure.microsoft.com/en-us/global-infrastructure/geographies/) that is closest to you and meet your needs

* Consider a [naming and tagging convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging) to organize your cloud assets to support identification on shared subscriptions

You can find a list of locations using the azure cli

```bash
az account list-locations -o table
```

**Example:** Since I am located in Denver, Colorado, I will opt to use the Data center region `West Central US` which is based in Wyoming! I will also use the following naming convention:  

```bash
<Asset_type>-<your_id_orname>-<location>-<###>
```

So for my AKS Cluster I will deploy in West Central US will use  `aks-armand-wcus-1` or just `aks-armand-wcus` since i dont intend to have more than one AKS deployment

## Quickstart: Deploy an Azure Kubernetes Service cluster using the Azure CLI

based on https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough


1. Create a [resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-cli)

```azurecli
MY_RG=rg-armand-westcentralus
az group create --name $MY_RG --location  westcentralus


{
  "id": "/subscriptions/402af119-0892-47bb-ab5b-27af70f3c63b/resourceGroups/rg-armand-westcentralus",
  "location": "westcentralus",
  "managedBy": null,
  "name": "rg-armand-westcentralus",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}

```

2.  Create a private [container registry](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-azure-cli) using the Azure CLI. 
    (Note: The registry name must be unique within Azure, and contain 5-50 alphanumeric characters )

```bash
MY_RG=rg-armand-westcentralus
MY_ACR=acrarmand 
MY_AKS=aks-armand-westcentralus-1

az acr create --resource-group $MY_RG \
  --name $MY_ACR --sku Basic
```

3. Create a 3 node [AKS cluster](https://azure.microsoft.com/en-us/services/kubernetes-service/) . You can also attach a given ACR instance to a new AKS cluster using the `--attach-acr` argument. **This may take a while...** (see troubleshooting below why I could not use  `--attach-acr` and `--enable-addons monitoring` options)

```bash
MY_RG=rg-armand-westcentralus
MY_ACR=acrarmand 
MY_AKS=aks-armand-westcentralus

az aks create --name $MY_AKS \
              --resource-group $MY_RG \
              --kubernetes-version 1.18.10 \
              --node-count 3 \
              --generate-ssh-keys 

[Finally after a long wait, some output here]
```


**Troubleshooting**:

```bash
Could not create a role assignment for ACR. Are you an Owner on this subscription?
```

The  error above, it means we are not a subscription owner role and lack sufficient rights to grant access to `acr`, therefore we cannot use the `--attach-acr` option.  A workaround we will need to use Kubernetes `secret` to integrate ACR and AKS to pull containers from ACR, or create a `ServiceAccount` in Kubernetes can provide custom configuration for pulling images.

See [3 Ways to integrate ACR with AKS](https://thorsten-hans.com/3-ways-to-integrate-acr-with-aks)


```bash
could not create a role assignment for Monitoring addon. Are you an Owner on this subscription?           
```

If you see the error above, it also means you in order for AKS to securely manage and provision your clusters you  should be owner or administrator of the subscription under which you are creating your AKS cluster

We can ignore this, and next time drop the `--enable-addons monitoring` option

4. Connect to the cluster so we can manage a Kubernetes cluster,  using [kubectl](https://kubernetes.io/docs/user-guide/kubectl/), the Kubernetes command-line client.  If you would like to use `kubectl` locally on your own machine (instead of Azure Cloud Shell) use the [az aks install-cli](https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-install-cli) command:

```bash
az aks install-cli
```

5. Configure `kubectl` to connect to your Kubernetes cluster using the [az aks get-credentials](https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-get-credentials) command. This command downloads credentials and configures the Kubernetes CLI to use them.

```azurecli
az aks get-credentials --resource-group $MYRG --name $MYAKS
```

6. Verify the connection to your cluster, use the [kubectl get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get) command to return a list of the cluster nodes.  Make sure that the status of the node is *Ready*

```
kubectl get nodes
```




