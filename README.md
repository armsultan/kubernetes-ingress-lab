# NGINX for Kubernetes lab

**WIP:** Collection of exercises to get acquainted with Kubernetes and exposing services in using NGINX

## Table of Contents:

1. Deploy Kubernetes to the cloud  
   1. [Amazon Web Services (AWS)](docs/aws/aws-cli-aks-ecr-setup-guide.md)
   2. Microsoft Azure - TODO
   3. Google Cloud Platform (GCP) - TODO
   4. Digital Ocean - TODO

2. [Deploy a sample application](docs/deploy-sample-applications/deploy-sample-application.md)

3. [Exposing Services in Kubernetes](docs/exposing-services/exposing-services-in-kubernetes.md)
1. [ClusterIP](docs/exposing-services/cluster-ip.md) 
   2. [Port-forward](docs/exposing-services/port-forward.md)
   3. [NodePort](docs/exposing-services/node-port.md) 
   4. [LoadBalancer](docs/exposing-services/load-balancer.) 
   5. [Ingress Controller](docs/exposing-services/ingress-controller.md)  - TODO



## TO DO / Ideas:



* Ingress vs VirtualServer and VirtualServerRoute resources
  * Ingress resource
  * VirtualServer resource
  * VirtualServerRoute resource

* Kubernetes ingress controllers
  *  Envoy
  *  HAProxy
  * Traefik
  *  NGINX
  * F5 / NGINX Plus

  

* NGINX Plus Ingress Controller
  * Config Migration: NGINX Open Source vs NGINX Plus
  * Real-time metrics 
    * NGINX Plus Dashboard
    * Grafana and Prometheus



* Zero/Minimizing Downtime During Deployments
* Benchmarking Ingress

* NGINX Ingress Operator on Red Hat OpenShift