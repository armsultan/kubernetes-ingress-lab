## Exposing services

**Cloud**

https://docs.microsoft.com/en-us/azure/aks/concepts-network#services

* **Cluster IP** - Creates an internal IP address for use  within the AKS cluster. Good for **internal-only** applications that support other workloads within the cluster.
* **NodePort** - Creates a port mapping on the underlying  node that allows the application to be accessed directly with the node  IP address and port.

* **LoadBalancer** - Creates an Azure load balancer  resource, configures an external IP address, and connects the requested  pods to the load balancer backend pool. To allow customers' traffic to  reach the application, load balancing rules are created on the desired  ports

* **Ingress controllers** -  When you create a `LoadBalancer` type Service, an underlying Azure load balancer resource is created. The load balancer is configured to  distribute traffic to the pods in your Service on a given port. The  `LoadBalancer` only works at layer 4 - the Service is unaware of the  actual applications, and can't make any additional routing  considerations.



**On Premise**

**... CIS + Ingress for on premise**





## Cluster IP

ClusterIP accesses the services through proxy. ClusterIP can access services only inside the cluster.

We can test this by running a simple HTTP client  inside your Kubernetes Cluster



 ![img](https://www.edureka.co/community/?qa=blob&qa_blobid=12695704322209366535)

1. We can deploy a utility container, [`network-tools`](https://hub.docker.com/r/armsultan/network-tools), pod to test requests to our `services `via it's `ClusterIP`

```
# Use this manifest to create our dnsutil Pod:
kubectl apply -f deployments/tools/network-tools.yaml

pod/network-tools created



# Verify its status
kubectl get pods network-tools

NAME      READY     STATUS    RESTARTS   AGE

network-tools   1/1       Running   0          <some-time>
```



2. Get the `ClusterIP` address for our **Coffee** and **Tea** services (`coffee-svc` and `tea-svc ` )



```
kubectl get services -n cafe

NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
coffee-svc   ClusterIP   10.100.104.173   <none>        80/TCP    50m
tea-svc      ClusterIP   10.100.23.145    <none>        80/TCP    50m
```

We can also save the `ClusterIP` addresses into variables for next step

```
# coffee-svc 
coffee_cluster_ip=$(kubectl get services/coffee-svc -n cafe | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

# tea-svc 
tea_cluster_ip=$(kubectl get services/tea-svc -n cafe | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
```



3. Now `exec` a `curl` command in that that pod to retrieve response header information from the coffee and tea services

```
# coffee-svc
kubectl exec -i -t network-tools -- curl http://$coffee_cluster_ip -I

HTTP/1.1 200 OK
Server: nginx/1.17.6
Date: Fri, 20 Nov 2020 20:43:22 GMT
Content-Type: text/html
Connection: keep-alive
Expires: Fri, 20 Nov 2020 20:43:21 GMT
Cache-Control: no-cache

# tea-svc
kubectl exec -i -t network-tools -- curl http://$tea_cluster_ip -I

HTTP/1.1 200 OK
Server: nginx/1.17.6
Date: Fri, 20 Nov 2020 20:52:35 GMT
Content-Type: text/html
Connection: keep-alive
Expires: Fri, 20 Nov 2020 20:52:34 GMT
Cache-Control: no-cache

```

