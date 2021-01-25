# Create an image pull secret to access your Private Registry

If your container images are kept in a private registry, you will need to create a secret which the Pods will use in order to pull an image. Remember, NGINX Plus Ingress should always be kept in a private registry

Examples where I have had to use secrets to enable integration between your kubernetes cluster and container registry:
 *  Pulling Container images from a private repository in Docker hub (not default access from any kubernetes platforms)
 * Integrating ACR and AKS using a Secret where you cannot configure a Azure Active Directory Service Principal for integration

## Create an image pull secret for Docker Hub

1. Create a Kubernetes Secret that can be referenced in the pod specification

```bash
# Edit the following commands with your own values
REG_NAME=armand
REG_PASS=something
MY_NAMESPACE=namespace

kubectl create secret docker-registry regcred \
 --docker-server=https://index.docker.io/v1/ \
 --docker-username=$REG_NAME \
 --docker-password=$REG_PASS \
 --docker-email=ignorethis@email.com \
 --namespace=$MY_NAMESPACE #important
```

## Create an image pull secret for Azure Container Registry

See [Pull images from an Azure Container Registry to a Kubernetes cluster](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-kubernetes)


1. Create a Kubernetes Secret that can be referenced in the pod specification

```bash
REG_NAME=youruniquename.azurecr.io
REG_UNAME=$(az acr credential show -n $ACR_NAME --query="username" -o tsv)
REG_PASS=$(az acr credential show -n $ACR_NAME --query="passwords[0].value" -o tsv)
MY_NAMESPACE=namespace

kubectl create secret docker-registry acr-secret \
  --docker-server=$REG_NAME \
  --docker-username=$REG_UNAME \
  --docker-password=$REG_PASS \
  --docker-email=ignorethis@email.com \
  --namespace=$MY_NAMESPACE #important
```

## Confirm Secret was uploaded correctly into specified namespace

1. The following coammands **will expose your password in plain text**

```bash
# WARNING: This command will expose your password in plain text
MY_NAMESPACE=namespace
kubectl get secret regcred --namespace=$MY_NAMESPACE \
  --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode

# Save regred in yaml format for future use:
MY_NAMESPACE=namespace
kubectl get secret regcred --namespace=$MY_NAMESPACE --output=yaml > regcred.yml
```