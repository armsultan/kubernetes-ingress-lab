# VirtualServer and VirtualServerRoute Resources vs ingress Resources

Kubernetes `Ingress` resources provide a way of  configuring incoming HTTP traffic was was not very extensible for the variety of use cases a ingress needed to support

The` VirtualServer` and `VirtualServerRoute` resources are new load  balancing configuration, introduced in release `1.5` as an alternative to  the `ingress` resource.  The resources are implemented as [Custom Resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/), or custom  resource definitions (CRDs)

 These resources enable use cases  supported with  the Ingress resource with less dependence on additional settings  via annotations or providing configuration blocks in `configmaps`, use cases include traffic splitting and advanced content-based routing and support for NGINX App protect



We will implement both `ingress` and `VirtualServer ` /  `VirtualServerRoute`for comparison, and explore some of the new functionality provided by the `VirtualServer` and `VirtualServerRoute` CRDs.



Sources:

https://octopus.com/blog/nginx-ingress-crds

https://docs.nginx.com/nginx-ingress-controller/configuration/virtualserver-and-virtualserverroute-resources/



## Deploy NGINX Ingress with `ingress` resources 



## Deploy NGINX Ingress with `VirtualServer` and `VirtualServerRoute` 



