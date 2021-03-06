## Deploy our Coffee and Tea Application

A [Kubernetes manifest
file](https://docs.microsoft.com/en-us/azure/aks/concepts-clusters-workloads#deployments-and-yaml-manifests)
defines the desired state for the cluster, such as what container images to run,
replica count, resource limits, and much more. In this demo, a manifest
specifies all objects needed to run the coffee and tea applications. 

We have a preconfigured manifest that includes two [Kubernetes
deployments](https://docs.microsoft.com/en-us/azure/aks/concepts-clusters-workloads#deployments-and-yaml-manifests)
- one for the **coffee** application and the other for a **tea** application;
both are simply NGINX web servers presenting a web page. Two [Kubernetes
Services](https://docs.microsoft.com/en-us/azure/aks/concepts-network#services)
are also created, one for each application, a `service` is a logical group of a
set of pods together and provide network connectivity. A `service` keeps track
of Pod Endpoints (IP address and ports) we can connect  to.

1. Make sure you have the Kubernetes command-line tool, `kubectl`, to run
   commands against Kubernetes clusters: **See [Install and Set Up
   kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)**

You can use kubectl to deploy applications, inspect and manage cluster
resources, and view logs. For a complete list of kubectl operations, see
[Overview of kubectl](https://kubernetes.io/docs/reference/kubectl/overview/).

For example, Installing on linux:

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
```

2. Review the the `deployments/cafe-app/cafe-app.yml`manifest file 

Noteworthy points about the `cafe-app.yml` manifest:

* It contains both Deployment and Service specification in the same file for
  **coffee** and **tea** applications.
* They are deployed in the **cafe** `namespace`.
* These sections are separated by the --- characters, which indicates the start
  of a document. All YAML files can optionally begin with `---` and end with
  `...` to mark the start and end of a document.

3. Create the **cafe**
   [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/),
   our "virtual cluster" where we deploy our coffee and tea application. Run the
   [kubectl
   apply](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply)
   to create our cafe namespace defined in a manifest file and run [kubectl
   get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get)
   to display one or many resources



```bash
# Create namespace
kubectl create -f deployments/cafe-app/cafe-namespace.yml

# Check that its exists in our cluster
kubectl get namespaces
NAME              STATUS   AGE
cafe              Active   10s  #<-- There it is!
default           Active   175m
kube-node-lease   Active   175m
kube-public       Active   175m
kube-system       Active   175m

```



4. Now that our **cafe** `namespace` exists, we can run the [`kubectl
   apply`](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply)
   again, this time to deploy the **coffee** and **tea** `deployments` and
   `services` on to our cluster. We can run [kubectl
   get](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get)
   again to display one or many resources we have deployed in the cafe
   `namespace`

```
# Create Coffee and Tea deployment and service
kubectl apply -f deployments/cafe-app/cafe-app.yml

deployment.apps/coffee created
service/coffee-svc created
deployment.apps/tea created
service/tea-svc created

# Get deployments,services in the cafe namespace
kubectl get pods,deployments,services -n cafe

NAME                          READY   STATUS    RESTARTS   AGE
pod/coffee-74c98dd7c8-kvs2b   1/1     Running   0          2m48s
pod/tea-7dcd6f57b6-kztrd      1/1     Running   0          2m48s

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/coffee   1/1     1            1           2m50s
deployment.apps/tea      1/1     1            1           2m49s

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/coffee-svc   ClusterIP   10.100.104.173   <none>        80/TCP    2m49s
service/tea-svc      ClusterIP   10.100.23.145    <none>        80/TCP    2m49s

```

`READY` and `AVAILABLE`  `1/1` and `STATUS Running` reassure us that everything
is working OK! 

## Scaling the deployment

1. To Scale out the coffee and tea deployments to multiple pods, we can edit the
   manifest `yaml` file and reapply the config or simply with a commandline: 

```bash
kubectl scale deployments/tea --replicas=3 -n cafe
kubectl scale deployments/coffee --replicas=4 -n cafe
```

2. Run the kubectl get command with `-o wide` option to see which Kubernetes
   worker nodes the coffee and tea pods were deployed on

Since we have deployed four coffee pods, we can see that one worker node is
hosting two pods

```bash
kubectl get pods,deployments,services -n cafe -o wide
```