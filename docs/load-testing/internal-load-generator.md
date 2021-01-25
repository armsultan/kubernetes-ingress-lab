# Internal traffic simulation using a Load Generator CronJob

In this lab exercise, we will create
[CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)
inside our Kubernetes cluster to simulate varying traffic loads in a 24hr
period.

Load testing your ingress or applications from a client within Kubernetes is not
optimal for benchmark testing performance since resources for the client will
draw resources from the Kubernetes cluster, potentially degrading the
performance of your ingress proxies and application components

An external test client is most suitable for performance benchmark testing. See
[EC2 test client setup](../AWS/ec2-test-client-setup.MD) as an guide on creating
a Virtual Machine for a external HTTP client

An internal load generator deployed within the Kubernetes cluster is suitable
for lightweight traffic generation to generate statistics and metrics.

1. Examine the yaml [manifest file](../../deployments/tools/daily-loadgen-cron.yaml) that will deploy a configMap and cronJob in the default namespace

Noteworthy points about the `configMap`:
 * The `configMap`, `loadgen-script`, encapsulates the `load.sh` bash script that sets the
   [`wrk2`](https://github.com/giltene/wrk2) paramteters for load generation
 * The average Rate in requests per second are defined in the bash script array,
   where index is the hour of the day in 24hr Time
 * The script will always use 20 connections to generate the provided rate per
   second

Noteworthy points about the `cronJob`:
 * The `cronJob`, `daily-loadgen-cron` runs the `load.sh` script periodically on
   a given schedule, written in Cron format.
 * We specify the scedule of `"* * * * *"` i.e., always

2. Edit the manifest file, [`daily-loadgen-cron.yaml`](../../deployments/tools/daily-loadgen-cron.yaml) and replace the hostname placeholder in the script arguments with a resolvable IP or hostname of your ingress, and a Host header value

If you have a `loadBalancer` routing traffic to your `ingress`, then insert that
hostname as the first argument along with any trailing url path. 

If you are using the [sample cafe
application](../deploy-sample-applications/deploy-sample-application.md), we
need to add a url path of `/coffee` or `/tea` and provide the Host header value
of `cafe.example.com`

For example:

```yaml
  #...
  - $(/bin/load.sh aaa46166a74b245848b806994ee554a0-1865443855.ap-southeast-2.elb.amazonaws.com/coffee cafe.example.com)
  #...
```

3. After modifying the manifest file,
   [`daily-loadgen-cron.yaml`](../../deployments/tools/daily-loadgen-cron.yaml)
   and saving changes, we can now apply the file to deploy both `configMap` and
   `cronJob`

```bash
kubectl apply -f deployments/tools/daily-loadgen-cron.yaml
```

4. Check both resources are deployed to your Kubernetes cluster in the default namespace

```bash
kubectl get configmaps
NAME             DATA   AGE
loadgen-script   1      25s

kubectl get cronjob
NAME                 SCHEDULE    SUSPEND   ACTIVE   LAST SCHEDULE   AGE
daily-loadgen-cron   * * * * *   False     6        39s             31m
```

5. You can immediately see traffic generated in the [NGINX Plus dashboard](../nginx-plus-ingress/expose-sample-app-with-ingress.md/#nginx-plus-dashboard)

Access the Live Activity Monitoring Dashboard using `kubectl port-forward` on a single Ingress Controller pod, run the following:

**Note:** The port is only forwarded while the kubectl process is running, and
so the following command will consume a terminal window

```bash
# Access the Live Activity Monitoring Dashboard
kubectl get pods --namespace=nginx-ingress
kubectl port-forward <nginx-plus-ingress-pod> 8080:8080 --namespace=nginx-ingress 
```

Then open the NGINX Plus dashboard in a web browser on
[http://127.0.0.1:8080/dashboard.html](http://127.0.0.1:8080/dashboard.html)

![NGINX Plus Dashboard](media/nginx-plus-dashboard.png)

6. If you have enable [NGINX Plus Ingress Controller metrics for
   Prometheus](../prometheus-and-grafana-integration/nginx-plus-ingress-controller-prometheus-manifests-install.md)
   and deployed [Prometheus and
   Grafana](../prometheus-and-grafana-integration/prometheus-and-grafana-helm-install.md)
   for monitoring, you should see the Grafana dashboards begin to report
   metrics, and after sometime the graphs should reflect the traffic generated
   as specified in our load generator script


## Clean up

lab-kubernetes-ingress on  main [!?]
➜ k delete configmaps/loadgen-script
configmap "loadgen-script" deleted

lab-kubernetes-ingress on  main [!?]
➜ k delete cronjob/daily-loadgen-cron
cronjob.batch "daily-loadgen-cron" deleted

