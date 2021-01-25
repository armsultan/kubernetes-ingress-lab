# Creating Kubernetes Secrets for TLS

A common reason to use a Kubernetes Secrets is to add a SSL/TLS certificate to a cluster secure traffic through Ingress Controllers. Kubernetes provides two ways to add a secret: 
 1. Directly using the `kubctl` command line, and 
 2. From a YAML source file
 
## Optional: Generate a self-signed test certificate for this excerise

1. Create a quick self-signed cert for `www.example.com`, valid for one year. This command produces two files: `www.example.com.key` and `www.example.com.cert`. In production, you would a more secure key and use it to obtain a certificate from a certificate authority.

```bash
openssl req -x509 -nodes \
    -days 365 \
    -newkey rsa:2048 \
    -keyout www.example.com.key \
    -out www.example.com.crt \
    -subj "/CN=www.example.com"
```


## Directly using the `kubctl` command line

1. Create a TLS secret in Kubernetes with the `kubectl` command:

```bash
kubectl create secret tls test-tls --key="www.example.com.key" --cert="www.example.com.crt"
```

2. Verify that it was added:

```bash
kubectl get secrets
```

3. To view the YAML source of the secret:

```bash
kubectl get secret test-tls -o yaml
```

4. Optional: To delete the secret, run:

```bash
kubectl delete secrets test-tls
```

## Using a YAML Source File

Create a YAML source file manually to create the secret. Ths provides better documentation and reproduction it is prefered to create files that specify the state of the system, which can be committed to a source repo (i.e. `git`).

1. The basic template of the YAML file is:

```yaml
apiVersion: v1
data:
  tls.crt:
  tls.key:
kind: Secret
metadata:
  name: test-tls
  namespace: default
type: kubernetes.io/tls
```

2. We need to **base64 encode** the key and certificate data (to Copy and paste into file)

```bash
cat www.example.com.crt | base64
cat www.example.com.key | base64
```

3. Paste the base64 encoded cert and key into the appropriate sections of the YAML file **as one line**. **Important:** Make sure your text editor doesn’t add any carriage returns to wrap the lines.

```yaml
apiVersion: v1
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZKKJQ0F...etc
  tls.key: LS0tLS1CRUdJTiBdJTiBSU0EgUFJJ...etc
kind: Secret
metadata:
  name: test-tls
  namespace: default
type: kubernetes.io/tls
```

4. Finally, use the YAML file to create the secret:

```bash
# Specify namespace with `-n` if required 
kubectl create -f tls.yaml
```

## References
 * [Kubernetes Docs: Managing TLS in a cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)
 * [Kubernetes Docs: Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
 * [Hands on your first Kubernetes secrets](https://www.padok.fr/en/blog/kubernetes-secrets)
