# Enable kubernetes to Pull an Image from your Private Registry

In the case here you container images are kept in a private registry, we need to create a secret which the Pods will use in order to pull an image. Remember, NGINX Plus Ingress should always be kept in a private registry

Examples where I have had to use secrets to enable integration between your kubernetes cluster and container registry:
 * Integrating ACR and AKS using a Secret where you cannot configure a Azure Active Directory Service Principal for integration
 *  Pulling Container images from a private repository in Docker hub (not default access from any kubernetes platforms)

1. Create a `Namespace` and a `ServiceAccount` called `nginx-ingress` for the NGINX Plus Ingress controller and where we will place our secret:

# Create Namespace "nginx-ingress" and ServiceAccount "nginx-ingress"

```bash
kubectl create namespace nginx-ingress
kubectl create ServiceAccount nginx-ingress
```

2.    Create a Kubernetes Secret called `regcred`, and it referenced in the pod specification (configured in a future step). We can set variables and pass into this script to create the secret,regcred quickly:

# Edit the following commands with your own values
kubectl create secret docker-registry regcred \
 --docker-server=https://index.docker.io/v1/ \
 --docker-username=[your_username] \
 --docker-password=[your_password] \
 --docker-email=[your_email] \
 --namespace=nginx-ingress #important

```

# AZURE Container Registry ACR Admin Account is enabled
REG_NAME=youruniquename.azurecr.io
REG_UNAME=$(az acr credential show -n $ACR_NAME --query="username" -o tsv)
REG_PASS=$(az acr credential show -n $ACR_NAME --query="passwords[0].value" -o tsv)

REG_NAME

kubectl create secret docker-registry acr-secret \
  --docker-server=$REG_NAME \
  --docker-username=$REG_UNAME \
  --docker-password=$REG_PASS \
  --docker-email=ignorethis@email.com
```

# Confirm Secret was uploaded correctly into specified namespace
# WARNING: This command will expose your password in plain text
kubectl get secret regcred --namespace=nginx-ingress --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decod

    Save regred in yaml format for future use:

kubectl get secret regcred --namespace=nginx-ingress --output=yaml > regcred.yml