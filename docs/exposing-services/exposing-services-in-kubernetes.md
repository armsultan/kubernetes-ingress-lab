## Exposing services in Kubernetes

Here you will find a collection of lab excerises to setup your Kuberntes Cluster in the Cloud and expore many options to expose your applications

1. If you have not have a Kuberntes Cluster ready, check out the quick [AWS cli, AKS and ECR Setup guide](../aws/aws-cli-aks-ecr-setup-guide.md)

2. Then deploy our sample [Coffee and Tea Application](../deploy-sample-applications/deploy-sample-applications.md)
3. Deploy and test the many ways to expose services in Kubernetes...

### Kubernetes in the Cloud

* [**ClusterIP**](cluster-ip.md) - Creates an internal IP address for use  within the AKS cluster. Good for **internal-only** applications that support other workloads within the cluster. ClusterIP on a service provides basic round-robin algorithm load balancing to the endpoints on the pods
* [**Port-forward**](port-forward.md) - enables quick access a port of a specific pod of your cluster. The Kubernetes API server will establish a single HTTP  connection between your` localhost` and the resource running on your  cluster.
* [**NodePort**](node-port.md) - Creates a port mapping on the underlying  node that allows the application to be accessed directly with the node  IP address and port. 
* [**LoadBalancer**](load-balancer.md) - Creates an Azure load balancer resource, configures an external IP address, and connects the requested  pods to the load balancer backend pool. To allow customers' traffic to  reach the application, load balancing rules are created on the desired  ports
* [**Ingress controllers**](ingress-controller.md) -  When you create a `LoadBalancer` type Service, an underlying Azure load balancer resource is created. The load balancer is configured to  distribute traffic to the pods in your Service on a given port. The  `LoadBalancer` only works at **layer 4** , so the service is unaware of the  actual applications, and can't make any additional routing  considerations.



### Kubernetes On Premise Specific

Here are some Additional options when deploying Kubernetes "on premise". They are not covered in this lab

*  [F5 Container Ingress Services](https://clouddocs.f5.com/containers/v2/) (That should be deployed with [NGINX Plus Kubernetes Ingress](https://www.nginx.com/products/nginx-ingress-controller/) :-) )

* [MetalLB](https://metallb.universe.tf/) (That should be deployed with [NGINX Plus Kubernetes Ingress](https://www.nginx.com/products/nginx-ingress-controller/) too! :-) )



## References

* [Network concepts for applications in Azure Kubernetes Service (AKS)](https://docs.microsoft.com/en-us/azure/aks/concepts-network#services)

* [How do I expose the Kubernetes services running on my Amazon EKS cluster?](https://aws.amazon.com/premiumsupport/knowledge-center/eks-kubernetes-services-cluster/)
* [Using a Service to Expose Your App](https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/)

