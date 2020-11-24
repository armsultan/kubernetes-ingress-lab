## NodePort



A **NodePort** exposes the **service** on a static port on the Kubernetes node IP address.

NodePorts are provisioned in the high port range (`30000-32767`)  by default, and so, NodePorts are unlikely to match a service’s intended port (for example, HTTP Port `80` may be exposed as `31020`).

To access the service from outside the cluster, you use the  public or private IP address of any worker node and the NodePort in the format `<IP_address>:<nodeport>`. Kubernetes worker nodes in VPC clusters typically do not have a public IP address and so you would need to connect to the NodePort from inside private VPC network. If there are external IPs routed to the nodes, then you should ensure firewall rules on all nodes allow access to the open port.



![Diagram showing NodePort traffic flow in an AKS cluster](https://docs.microsoft.com/en-us/azure/aks/media/concepts-network/aks-nodeport.png)



## Setup NodePort 

1. Review the `deployments/cafe-app/cafe-app-nodeport.yml`manifest file

Noteworthy points about the `deployments/cafe-app/cafe-app-nodeport.yml`manifest:

* It contains both Deployment and Service specification in the same file for **coffee** and **tea** applications

* They are deployed in the **cafe** `namespace`
* NodePort is been enabled using `type: NodePort` in the `Service` Deployment
* A port was not specified (commented out), therefore, the Kubernetes system will chose a port in that range for you in the default `30000-32767` range.  

**Note:** You can set the NodePort range on your API server using the   `--service-node-port-range` option. 



2. Apply the `cafe-app-nodeport.yml`manifest to (re)deploy the **Coffee** and **Tea** services (`coffee-svc` and `tea-svc ` ) with `NodePort` Enabled

```
kubectl apply -f deployments/cafe-app/cafe-app-nodeport.yml
```

**Note:** This could also be achieved by updating a existing deployment with `NodePort` type, using the following imperative command: 

`````
kubectl expose deployment coffee  --type=NodePort  --name=coffee-svc
kubectl expose deployment tea  --type=NodePort  --name=tea-svc
`````

3. Confirm the **Coffee** and **Tea** services (`coffee-svc` and `tea-svc ` ) are now `TYPE NodePort`. You will see the `NodePort`mappings under `PORT(S)`. Also You will notice that `ClusterIP` address for those services coexist with `NodePort` 

In the example below we see `Nodeport` `31231` map to `80`for `coffee-svc`, and `Nodeport` ` 30095` to `80`for `tea-svc`:

```
kubectl get deployments,services -n cafe

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/coffee   1/1     1            1           3d9h
deployment.apps/tea      1/1     1            1           3d9h

NAME                 TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
service/coffee-svc   NodePort   10.100.104.173   <none>        80:31231/TCP   3d9h
service/tea-svc      NodePort   10.100.23.145    <none>        80:30095/TCP   3d9h
```

Now we have the `NodePort` address, we still need to pair that port with a the Kubernetes Node's IP address or FQDN to access from a external client. We can find that out in the next step

4. Get the Kubernetes worker Nodes` External-IP` using the following command

```
kubectl get nodes -o wide |  awk {'print $1" " $2 " " $7'} | column -t

NAME                                          STATUS  EXTERNAL-IP
ip-192-168-23-171.us-west-2.compute.internal  Ready   34.215.33.171
ip-192-168-48-90.us-west-2.compute.internal   Ready   54.191.50.101
ip-192-168-89-32.us-west-2.compute.internal   Ready   18.236.253.30


```

5. Before we test accessing **NodeIP:NodePort** from an outside cluster, we need to modify the security group of the nodes to **allow incoming traffic** through the port `30000-32767`.

```
MY_EKS=eks-armand-uswest2
MY_CLUSTER_SECURITY_GROUP_ID=$(aws eks describe-cluster --name $MY_EKS \
	--query 'cluster.resourcesVpcConfig.clusterSecurityGroupId' \
	--output text)
	
	# THIS WORKS
aws ec2  describe-security-groups \
	--filters "Name=tag:eksctl.cluster.k8s.io/v1alpha1/cluster-name,Values=$MY_EKS" \
	--query 'SecurityGroups[*].GroupName' 
	

# Update our security group to allow TCP 30000-32767
aws ec2 authorize-security-group-ingress \
	--group-id $MY_CLUSTER_SECURITY_GROUP_ID \
	--protocol tcp \
	--port 30000-32767 \
	--cidr 0.0.0.0/0
	
# Confirm FromPort and ToPort
aws ec2  describe-security-groups \
	--group-id $MY_CLUSTER_SECURITY_GROUP_ID

	--filters "Name=tag:eksctl.cluster.k8s.io/v1alpha1/cluster-name,Values=$MY_EKS" \


 "Key": "eksctl.cluster.k8s.io/v1alpha1/cluster-name",
                    "Value": "eks-armand-uswest2"

	
	$ aws ec2 create-security-group --group-name my-sg --description "My security group" --vpc-id vpc-1a2b3c4d
{
    "GroupId": "sg-903004f8"
}

$ aws ec2 authorize-security-group-ingress --group-id sg-903004f8 --protocol tcp --port 3389 --cidr 203.0.113.0/24

```

## Test NodePort from a External client

We can test External access to our applications using `Nodeport` from a  HTTP client **external to  your Kubernetes Cluster**, on cloud environments, you can deploy a simple Linux Client machine in your VPC

For AWS, follow [EC2 instance client setup](ec2-instance-client-setup.md)

Once you have setup a Linux machine, follow the steps below

```
NODE_EXTERNAL_IP=54.191.50.101
NODEPORT_COFFEE=31231
NODEPORT_TEA=30095

# Coffee Service
curl http://$NODE_EXTERNAL_IP:$NODEPORT_COFFEE -I

# Tea Service
curl http://$NODE_EXTERNAL_IP:$NODEPORT_TEA -I


curl http://34.215.33.171:31231 -I -H "Host coffee.cafe.com"

curl http://18.236.253:31231 -I -H "Host coffee.cafe.com"


 18.236.253.
```

references

https://medium.com/faun/learning-kubernetes-by-doing-part-3-services-ed5bf7e2bc8e

```yaml
kubectl port-forward $(kubectl get pod -l "app=coffee-svc" -o jsonpath={.items[0].metadata.name}) 31231
```



## port-forward



## Forward a local port to a port on the Pod



`kubectl port-forward` makes a specific [Kubernetes API request](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#-strong-proxy-operations-pod-v1-core-strong-).  That means the system running it needs access to the API server, and  any traffic will get tunneled over a single HTTP connection.

Having this is really useful for debugging (if one specific pod is  acting up you can connect to it directly; in a microservice environment  you can talk to a back-end service you wouldn't otherwise expose) but  it's not an alternative to setting up service objects.  When I've worked with `kubectl port-forward` it's been visibly slower than  connecting to a pod via a service, and I've found seen the command just  stop after a couple of minutes.  Again these aren't big problems for  debugging, but they're not what I'd want for a production system.

`kubectl port-forward` allows using resource name, such as a pod name, to select a matching pod to port forward to.

```shell
# Change redis-master-765d459796-258hz to the name of the Pod
kubectl port-forward coffee-74c98dd7c8-kvs2b -n cafe 31231
```