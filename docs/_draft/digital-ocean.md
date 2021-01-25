# Setup a Kubernetes Cluster on Digital Ocean

## Install `doctl`

1. Install, `doctl` is the official DigitalOcean command line interface (CLI): [How to Install and Configure doctl ](https://www.digitalocean.com/docs/apis-clis/doctl/how-to/install/). It is available from your operating system's package manager or as a [docker container](https://hub.docker.com/r/digitalocean/doctl)

## Create a new Kubernetes cluster

Refer to [Kubernetes on DigitalOcean](https://www.digitalocean.com/docs/kubernetes/) for more details on this service

### Create a new Kubernetes cluster in Digial ocean from the Digital Ocean dashboard

 1. Choose a datacenter region - Select a datacenter nearest to you
 2. Provide a **NODE POOL NAME** - anything descriptive
 3. Select a **MACHINE TYPE (DROPLET)** - "Standard nodes" is sufficent for our demo
 4. **NODE PLAN** - Smallest, "$10/Month per node ($0.015/hr)" is sufficent for our demo
 5. **NUMBER NODES** - 3

### Create a new Kubernetes cluster in Digial ocean using  `doctl`

1. Create a new project

```bash
doctl projects create --name getting-started-dgo --purpose testing
doctl projects list
# grab the project ID
```

2. Gather our options - Refer to [Kubernetes on DigitalOcean](https://www.digitalocean.com/docs/kubernetes/) for details on the available configuration options
   
3. 
```bash
doctl kubernetes options
doctl kubernetes options regions
doctl kubernetes options versions
```

4. Create our cluster
```bash
# full list of options
doctl kubernetes cluster create --help

doctl kubernetes cluster create k8s-digital-ocean \
--version 1.17.5-do.0 \
--count 1 \
--size s-1vcpu-2gb \
--region sgp1
```

4. Get a `kubeconfig` for our cluster

```bash
doctl kubernetes cluster kubeconfig save k8s-digital-ocean

#grab the config if you want it
cp ~/.kube/config .
```

## 1. Client Setup

You can install these while your cluster is being provisioned:

1. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/), the official Kubernetes client. Use version 1.15.3 of kubectl to ensure you are within one minor version of your cluster's Kubernetes version.
2. [doctl](https://github.com/digitalocean/doctl), the official DigitalOcean command-line tool. Use the latest version.
3. Download the configuration file from the Digial Ocean dashboard or use `doctl` to renew the certificates and fetch your `kubeconfig` configuration files

### Add the Digital Ocean Kubernetes config to your local kube config

There are two options to do this:

##### 1. `kubetctl` to import Digital Ocean kube config

1. Merge existing kube config with you new kube config:

```bash
KUBECONFIG=~/.kube/config:~/Downloads/my_new_kubeconfig.yaml \
  kubectl config view --flatten > ~/.kube/config
```

##### 2. `doctl` to import Digital Ocean kube config

1. To fetch using `doctl`, This downloads the kubeconfig for the cluster and automatically merges it with any existing configuration from `~/.kube/config`:
```bash

cd ~/.kube && kubectl --kubeconfig="k8s-1-16-2-do-0-sfo2-1573497597413-kubeconfig.yaml" get nodes
```

```bash
# Where k8s-armand is your cluster name (check your kubernetes/clusters dashboard)
doctl kubernetes cluster kubeconfig save k8s-armand

Notice: adding cluster credentials to kubeconfig file found in "/Users/armand/.kube/config"
Notice: setting current-context to k8s-armand
```

### Change context to your Digital Ocean Kubernetes cluster:

1. To use your Digital Ocean kubernetes cluster you will need to switch context

```bash
# Get a list of kubernetes clusters in you local kube config
kubectl config get-clusters
NAME
local-k8s-cluster
azure-k8s-cluster
do-sfo2-k8s-1-16-2-do-0-sfo2-1573497597413

# Set context
kubectl config set-context do-sfo2-k8s-1-16-2-do-0-sfo2-1573497597413
Context "do-sfo2-k8s-1-16-2-do-0-sfo2-1573497597413" modified.

# Check which context you are currently targeting
kubectl config current-context
do-sfo2-k8s-1-16-2-do-0-sfo2-1573497597413

# Get Nodes in the target kubernetes cluster
kubectl get nodes

NAME                  STATUS   ROLES    AGE     VERSION
pool-ubv6joskj-e2pd   Ready    <none>   4m9s    v1.16.2
pool-ubv6joskj-e2pi   Ready    <none>   3m40s   v1.16.2
pool-ubv6joskj-e2pv   Ready    <none>   3m45s   v1.16.2
```

You are ready to setup the [`nginx-ingress` demo](readme.md)


# Clean up

```bash
octl kubernetes cluster delete k8s-digital-ocean

# remember to delete the load balancer manually!
```