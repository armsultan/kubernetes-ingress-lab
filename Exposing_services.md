## Exposing services

**Cloud**

https://docs.microsoft.com/en-us/azure/aks/concepts-network#services

READ https://cloud.ibm.com/docs/containers?topic=containers-cs_network_planning

* **Cluster IP** - Creates an internal IP address for use  within the AKS cluster. Good for **internal-only** applications that support other workloads within the cluster.
* **NodePort** - Creates a port mapping on the underlying  node that allows the application to be accessed directly with the node  IP address and port.

* **LoadBalancer** - Creates an Azure load balancer  resource, configures an external IP address, and connects the requested  pods to the load balancer backend pool. To allow customers' traffic to  reach the application, load balancing rules are created on the desired  ports

* **Ingress controllers** -  When you create a `LoadBalancer` type Service, an underlying Azure load balancer resource is created. The load balancer is configured to  distribute traffic to the pods in your Service on a given port. The  `LoadBalancer` only works at layer 4 - the Service is unaware of the  actual applications, and can't make any additional routing  considerations.



**On Premise**

**... CIS + Ingress for on premise**





