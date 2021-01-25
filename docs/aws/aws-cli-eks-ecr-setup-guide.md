# AWS cli, EKS and ECR Setup guide

In this lab excerise we will create a  managed kubernetes cluster along with a
Container registry on AWS  EKS and ECR 

### What is AWS EKS?

Amazon Elastic Kubernetes Service is a service provided for Kubernetes on AWS
infrastructure. The Kubernetes resources will be fully managed by AWS, which
offloads the burden on maintaining the infrastructure, and makes sure these
resources are highly available and reliable at all times

### What is AWS ECR?

Amazon Elastic Container Registry managed container registry. Like the popular
docker registry Dockerhub, ECR also supports private and public repositories. We
can either push or pull images to ECR using AWS CLI.

## AWS Regions, Availability Zones and naming convention suggestions



1. Check out the available [AWS
   Regions](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html).
   Decide on a [Datacenter
   region](https://aws.amazon.com/about-aws/global-infrastructure/) that is
   closest to you and meets your needs. Check out the [AWS latency
   test](https://ping.psa.fun/)! We will need to choose one and input a region
   name in the following steps.
2. Consider a naming and tagging convention to organize your cloud assets to
   support user identification of shared subscriptions.

**Example:** 

I am located in Denver, Colorado; I will opt to use the Datacenter region
`us-west-2` based in US West (Oregon). I could also use the following naming
convention:

```bash
<Asset_type>-<your_id_yourname>-<location>-<###>
```

So for my EKS Cluster I will deploy in US West (Oregon), i.e., `us-west-2 `, and
will name my Cluster `eks-armand-us-west-2` or just `aks-armand-uswest2` since I
don't intend to have more than one EKS deployment

I will also use the tag `user=armand` to further identify my asset on our shared
account

## AWS CLI Basic Setting(Configuration and Credential File Settings)

We will need AWS Command Line Interface (CLI) installed on your client machine
to manage your AWS services. See [Installing, updating, and uninstalling the AWS
CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)



1. Configure client using `aws configure`

```bash
# Access your "My Security Credentials" section in your profile. 
# Create or Obtain your access key

aws configure

AWS Access Key ID [None]: [YOUR KEY]
AWS Secret Access Key [None]: [YOUR KEY]
Default region name [None]: us-west-2
Default output format [None]: json
```

We can inspect the files generated by the CLI using the `aws configure`  

3. Check `~/.aws/credentials` settings

```bash
cat ~/.aws/credentials

[default]
aws_access_key_id = [YOUR KEY]
aws_secret_access_key = [YOUR KEY]
```

4. Check `~/.aws/config`  setting

```bash
cat ~/.aws/config

[default]
region = us-west-2
output = json
```

Note: For file examples with multiple named profiles, see [Named
profiles](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html).


5.  Let try our first aws cli command. Get a list of all of the Regions that are
    enabled for your account:

```bash
aws ec2 describe-regions | grep RegionName
```

## Deploy a Kubernetes Cluster with AWS CLI

You can deploy a cluster using multiple ways. Check out the See [Getting started
with
`eksctl`](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)

 We will only cover the **EKS CLI**

1. [AWS](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html)
   CLI 
2. [EKS](https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html)
   CLI, `eksctl` (newer) 



### Amazon Elastic Kubernetes Service (EKS) Setup using [`eksctl`](https://eksctl.io/) 

[eksctl](https://eksctl.io/) is a simple CLI tool for creating clusters on EKS;
eksctl is now the [official command line for
EKS](https://aws.amazon.com/blogs/opensource/eksctl-eks-cli/)

Check out [Installing or upgrading eksctl](https://eksctl.io/) and review some
standard command-line options in the [eksctl
introduction](https://eksctl.io/introduction/)

#### Setup Amazon EKS

1. For this demo, we will be creating an EKS cluster using the `eksctl` tool. We
   can test that our installation was successful with the following command.

```bash
eksctl version
```

2. Use `eksctl` to create a production-ready EKS cluster with  some options in a
   single command (**This will take a while**):

```bash
MY_REGION=us-west-2
MY_EKS=eks-armand-uswest2
MY_NAME=armand

eksctl create cluster \
     --name=$MY_EKS \
     --region=$MY_REGION \
     --nodes=3 \
     --tags user=$MY_NAME \
     --version=1.18
```

3. To create or update the `kubeconfig` file for your cluster, run the following
   command:

```bash
MY_REGION=us-west-2
MY_EKS=eks-armand-uswest2

aws eks --region $MY_REGION update-kubeconfig --name $MY_EKS
```

4. If you are managing multiple Kubernetes clusters, you can easily change
   between context using the `kubectl config set-context` command:

```bash
# Get a list of kubernetes clusters in you local kube config
kubectl config get-clusters
NAME
local-k8s-cluster
azure-k8s-cluster
do-sfo2-k8s-1-16-2-do-0-sfo2-1573497597413
arn:aws:eks:us-west-2:664341837355:cluster/eks-armand-uswest2

# Set context
kubectl config set-context eks-armand-uswest2

# Check which context you are currently targeting
kubectl config current-context

# Get Nodes in the target kubernetes cluster
kubectl get nodes

NAME                                           STATUS   ROLES    AGE     VERSION
ip-192-168-23-171.us-west-2.compute.internal   Ready    <none>   3m10s   v1.18.9-eks-d1db3c
ip-192-168-48-90.us-west-2.compute.internal    Ready    <none>   3m6s    v1.18.9-eks-d1db3c
ip-192-168-89-32.us-west-2.compute.internal    Ready    <none>   3m5s    v1.18.9-eks-d1db3c

```

## Create an AWS Container Registry (ECR)

For additional registry authentication methods, including the Amazon ECR
credential helper, see [Registry
Authentication](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Registries.html#registry_auth).
Also, refer to the AWS [ECR user
guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/get-set-up-for-amazon-ecr.html)
for tips and best practices for [creating the
repository](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-create.html).



**On Shared Registry and Repositories** : The URL for your default registry is
`https://$MY_AWS_ACCOUNT_ID.dkr.ecr.$MY_REGION.amazonaws.com` , and by default,
your account has read and write access to the repositories in your default
registry. In the next step we can log the registry using the `aws ecr` command. 

On **shared corporate accounts** you will be using a **shared Container
registry** and so you should consider prepending a unique name for the a
namespace to group  the repository into a category , i.e. your own group. For
example, the repository name may be specified on its own (such as
`nginx-web-app`) or it can be prepended with a namespace to group the repository
into a category or user  (such as `armand/nginx-web-app`).



[### Create your ECR](#authenicate-to-ecr)

1. Retrieve an authentication token and authenticate your Docker client to your
   registry  using the `aws ecr` command:

```bash
MY_AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
MY_REGION=us-west-2

aws ecr get-login-password --region $MY_REGION | docker login --username AWS --password-stdin $MY_AWS_ACCOUNT_ID.dkr.ecr.$MY_REGION.amazonaws.com
```

At the end of the output you should see `Login Succeeded`!

### Test access to your ECR 

We can quickly test the ability to push images to our Private ECR from our
client machine

Take note of the image URIs in your private registry that is created from the
following steps. We will need it for when we push container images to the
registry



1. Create an ECR repository for your container images

```bash
MY_REGION=us-west-2
MY_REPO="armand/hello-world"

aws ecr create-repository --repository-name $MY_REPO --region $MY_REGION
```



2. If you do not have a test container image to push to ECR, you can download a
   simple container for testing, e.g.
   [armsultan/hello-world](https://hub.docker.com/r/armsultan/hello-world)

```bash
docker pull armsultan/hello-world
```

2. Get the image ID so we can tag it on the next step

```bash
docker images | grep hello-world
armsultan/hello-world    latest         15d53731c307        6 minutes ago       1.23MB
```

3. Tag the image with your registry uri

```bash
MY_AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
MY_REGION=us-west-2
MY_REPO="armand/hello-world"
MY_IMAGE_ID=15d53731c307

docker tag $MY_IMAGE_ID $MY_AWS_ACCOUNT_ID.dkr.ecr.$MY_REGION.amazonaws.com/$MY_REPO
```

4.  Your newly tagged image is now listed under `docker images`:

```bash
docker images | grep hello-world
664341837355.dkr.ecr.us-west-2.amazonaws.com/armand/hello-world   latest              15d53731c307        11 minutes ago      1.23MB
armsultan/hello-world                                             latest              15d53731c307        11 minutes ago      1.23MB
```

4. Push your tagged image to ECR

```bash
# you can get copy the docker image name from the last step 
docker push 664341837355.dkr.ecr.us-west-2.amazonaws.com/armand/hello-world 
```

5. Check it is up there using the aws cli

```bash
MY_REGION=us-west-2

aws ecr describe-repositories --region $MY_REGION | grep hello-world

# example output:
            "repositoryArn": "arn:aws:ecr:us-west-2:664341837355:repository/armand/hello-world",
            "repositoryName": "armand/hello-world",
            "repositoryUri": "664341837355.dkr.ecr.us-west-2.amazonaws.com/armand/hello-world",
```

## Uninstall and Delete your EKS cluster 

You can easily delete your EKS cluster using the `eksctl` tool

1. Delete the cluster and its associated nodes with the following command,
   replacing `$MY` with your cluster name. 

```bash
$MY_EKS=eks-armand-uswest2
eksctl delete cluster $MY_EKS
```

## References

* [TWpower's Tech Blog: Create, list and delete EC2 instance using AWS
  CLI](https://twpower.github.io/210-create-list-delete-ec2-instance-using-aws-cli-en)
