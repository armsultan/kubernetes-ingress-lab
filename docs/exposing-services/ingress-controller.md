# Ingress controller

The Ingress controller is an application that runs in a Kubernetes cluster and
configures an HTTP load balancer according to
[`Ingress`](https://kubernetes.io/docs/concepts/services-networking/ingress/)
resources. 

`Ingress` exposes HTTP/S routes from outside the cluster to services within the
cluster.

You must have an Ingress controller to satisfy an Ingress. Only creating an
Ingress resource has no effect.

The `Ingress` resource isn’t a dedicated service, however `Ingress` exposes
HTTP/S routes from outside the cluster to services within the cluster and t just
describes a set of rules for the Kubernetes Ingress Controller to create a Load
Balancer proxy, its Listeners, and routing rules for them.

The load balancer proxy can be a software load balancer running in the cluster
or a hardware load balaner or cloud load balancer running externally. Different
load balancers require different Ingress controller implementations.

Both, AWS' [Application Load Balancer (ALB) Ingress
Controller](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html)
and Azure's [Application Gateway Ingress Controller
(AGIC)](https://docs.microsoft.com/en-us/azure/application-gateway/ingress-controller-overview)
utilize the cloud native Load balancer solution for Ingress while NGINX, a
platform agnostic Ingress controller is deployed in a pod along with the load
balancer.

## Install an Ingress Controller
### NGINX Plus Ingress Controller
 * [Install NGINX Plus Ingress Controller using
   Manifests](../nginx-plus-ingress/nginx-plus-ingress-controller-manifests-install.md)
 * Install NGINX Plus Ingress Controller using Helm - todo

### Other Ingress Controllers
 * [NGINX OpenSource
   (`kubernetes/ingress-oss`)](https://kubernetes.github.io/ingress-nginx/deploy/)
 * [Envoy based Proxies](https://www.envoyproxy.io/community)
 * [HAProxy](https://haproxy-ingress.github.io/docs/getting-started/)
 * [Traefik](https://doc.traefik.io/traefik/getting-started/install-traefik/)
