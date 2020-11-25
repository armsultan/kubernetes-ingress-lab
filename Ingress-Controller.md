# `Ingress`

Actually, the `Ingress` isn’t a dedicated Service – it  just describes a set of rules for the Kubernetes Ingress Controller to  create a Load Balancer, its Listeners, and routing rules for them.

The documentation is [here>>>](https://rtfm.co.ua/goto/https://kubernetes.io/docs/concepts/services-networking/ingress/).

In case of AWS, it will be the ALB Ingress Controller – see the [ALB Ingress Controller on Amazon EKS](https://rtfm.co.ua/goto/https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html) and [AWS Elastic Kubernetes Service: запуск ALB Ingress controller](https://rtfm.co.ua/en/aws-elastic-kubernetes-service-running-alb-ingress-controller/).

To make it working, `Ingress` require an additional Service where `Ingress` will route traffic to – kind of a backend.

[![Kubernetes: ClusterIP vs NodePort vs LoadBalancer, Services и Ingress - обзор, примеры](https://rtfm.co.ua/wp-content/uploads/2020/06/1_KIVa4hUVZxg-8Ncabo8pdg.png)](https://rtfm.co.ua/wp-content/uploads/2020/06/1_KIVa4hUVZxg-8Ncabo8pdg.png)

For the ALB Ingress Controller a manifest with the `Ingress` and its Service can be the next:



## Resources



https://rtfm.co.ua/en/kubernetes-clusterip-vs-nodeport-vs-loadbalancer-services-and-ingress-an-overview-with-examples/