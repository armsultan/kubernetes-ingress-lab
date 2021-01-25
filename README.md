# NGINX for Kubernetes lab

**WIP:** Collection of exercises to get acquainted with Kubernetes and exposing services in using NGINX

## Table of Contents:

1. Deploy Kubernetes to the cloud  
   1. [Amazon Web Services (AWS) - EKS and ECR](docs/aws/aws-cli-eks-ecr-setup-guide.md)

2. [Deploy a sample application](docs/deploy-sample-applications/deploy-sample-application.md)

3. [Exposing Services in Kubernetes](docs/exposing-services/exposing-services-in-kubernetes.md)
   1. [ClusterIP](docs/exposing-services/cluster-ip.md) 
   2. [Port-forward](docs/exposing-services/port-forward.md)
   3. [NodePort](docs/exposing-services/node-port.md) 
   4. [LoadBalancer](docs/exposing-services/load-balancer.md) 
   5. [Ingress Controller](docs/exposing-services/ingress-controller.md)

4. Install NGINX Plus Ingress Controller
   1. [Install NGINX Plus Ingress Controller using Manifests](docs/nginx-plus-ingress/nginx-plus-ingress-controller-manifests-install.md)
   2. Install NGINX Plus Ingress Controller using Helm - todo

5. Expose a sample application with the ingress Controller
   1. [Expose a sample application with `ingress`](docs/nginx-plus-ingress/expose-sample-app-with-ingress.md)
   2. Expose a sample application with `VirtualServer` and `VirtualServerRoute` - todo

6. NGINX Plus Ingress Controller Real-time metrics 
   * [NGINX Plus Dashboard - Live Activity Monitoring](docs/nginx-plus-ingress/expose-sample-app-with-ingress.md/#nginx-plus-dashboard)
   * Grafana and Prometheus
      * [Install `kube-prometheus-stack` using Helm](docs/prometheus-and-grafana-integration/prometheus-and-grafana-helm-install.md)
      * [Enable NGINX Plus Ingress Controller metrics for Prometheus using Kubernetes manifests](docs/prometheus-and-grafana-integration/nginx-plus-ingress-controller-prometheus-manifests-install.md)

7. Load Testing Ingress
   * [EC2 test client setup](docs/aws/ec2-test-client-setup.md)

## TO DO / Ideas:

* Deploy Kubernetes to the cloud  
  * Microsoft Azure 
  * Google Cloud Platform (GCP) 
  * Digital Ocean 

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


* open-tracing 
* Config Migration: NGINX Open Source vs NGINX Plus

* Zero/Minimizing Downtime During Deployments
* Benchmarking Ingress

* NGINX Ingress Operator
* NGINX Ingress Operator on Red Hat OpenShift