



## EC2 instance client setup

### Security group and key-pair for Public Key authentication for SSH

We can NodePort this by running a simple HTTP client inside your VPC, outside your kubernetes cluster.  To access our client externally need to have an appropirate security group set and a key-pair to connect over SSH

If this is not already created, You can make security group in the AWS mangement console website, or follow the instructions to set up security group, key-pair and EC2 instance using the AWS CLI

1. Create a **Security group** to open **only the SSH port in inbound and opens all ports in outbound**. You can make security group in aws website or create a security group for instance for remote SSH port 22 Access:

```bash
MY_SECURITY_GROUP=security-group-uswest2-armand

aws ec2 create-security-group --group-name $MY_SECURITY_GROUP --description "security group with open port 22"

aws ec2 authorize-security-group-ingress --group-name $MY_SECURITY_GROUP \
	--protocol tcp \
	--port 22 \
	--cidr 0.0.0.0/0
															
aws ec2 describe-security-groups --group-names $MY_SECURITY_GROUP
```

To get the security group ID for later steps you can use the following query filter

```
MY_SECURITY_GROUP=security-group-uswest2-armand

MY_SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --group-names $MY_SECURITY_GROUP --query 'SecurityGroups[*].[GroupId]' --output text)

echo $MY_SECURITY_GROUP_ID
```

2. Create a **key-pair** for **Public Key authentication for SSH**. You can use your own key pair. However, public key should be in AWS and private key should be kept in your computer.

```
MY_KEY_PAIR=keypair-armand

aws ec2 create-key-pair --key-name $MY_KEY_PAIR --output text > $MY_KEY_PAIR.pem
```

### Launch EC2 Instance

1.  Launch a `t2.micro` instance in the specified subnet of a VPC. Replace the `[my_image_id]` parameter values with your own. To find the `image-id` you need, check out [Finding a Linux AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html), or other resources such as [Ubuntu Cloud Image Finder](https://cloud-images.ubuntu.com/locator/), note that **AMI IDs are unique to each AWS Region**, therefore ensure you have found a AMI available in your VPC region.                            

#### Create EC2 instance

- `--image-id`: Find a image in your region using [Ubuntu Cloud Image Finder](https://cloud-images.ubuntu.com/locator/),
  - e.g. `ami-082e4f383a98efbe9`: Ubuntu 20.04 LTS (HVM), SSD Volume Type, in us-west-2
- `--count`: `1` 
- `--key-name`: reference your key-pair, 
  - e.g.`$MY_KEY_PAIR`, the key pair that we made above
- `--security-group-ids`: Security group ID

```
MY_KEY_PAIR=keypair-armand
MY_NAME=armand
MY_SECURITY_GROUP=security-group-uswest2-armand
MY_SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --group-names $MY_SECURITY_GROUP --query 'SecurityGroups[*].[GroupId]' --output text)
MY_EC2_NAME=ec2-uswest2-armand
MY_IMAGE_ID=ami-082e4f383a98efbe9

aws ec2 run-instances \
	--image-id $MY_IMAGE_ID \
	--count 1 \
	--instance-type t2.micro \
	--key-name $MY_KEY_PAIR \
	--security-group-ids $MY_SECURITY_GROUP_ID \
	--tag-specifications "ResourceType=instance,Tags=[{Key=user,Value=$MY_NAME},{Key=Name,Value=$MY_EC2_NAME}]" 
```

2. Retrieve the Instance ID and Public IP Address. We will use these commands later  

``` 
MY_EC2_NAME=ec2-uswest2-armand

aws ec2 describe-instances \
	--filters "Name=tag:Name,Values=$MY_EC2_NAME" \
	--query 'Reservations[].Instances[].InstanceId' \
	--output text


aws ec2 describe-instances \
	--filters "Name=tag:Name,Values=$MY_EC2_NAME" \
  --query "Reservations[*].Instances[*].PublicIpAddress" \
  --output=text
```

3. Check out [General prerequisites for connecting to your instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connection-prereqs.html) , to find out the default username for the AMI that you used to launch your instance. Generally it is:

```
* For Amazon Linux 2 or the Amazon Linux AMI, the user name is ec2-user.
* For a CentOS AMI, the user name is centos.
* For a Debian AMI, the user name is admin.
* For a Fedora AMI, the user name is ec2-user or fedora.
* For a RHEL AMI, the user name is ec2-user or root.
* For a SUSE AMI, the user name is ec2-user or root.
* For an Ubuntu AMI, the user name is ubuntu.
* Otherwise, if ec2-user and root don't work, check with the AMI provider..
```

#### Connect to EC2 instance

1. Set key file permission and Access to instance using ssh

```
MY_KEY_PAIR=keypair-armand
MY_EC2_NAME=ec2-uswest2-armand
MY_EC2_PUBLIC_IP=$(aws ec2 describe-instances \
	--filters "Name=tag:Name,Values=$MY_EC2_NAME" \
  --query "Reservations[*].Instances[*].PublicIpAddress" \
  --output=text)
MY_USERNAME=ubuntu #e.g. Ubuntu AMI

chmod 400 keypair-armand.pem
ssh -i keypair-armand.pem $MY_USERNAME@$MY_EC2_PUBLIC_IP
```



**Troubleshooting:** If you are getting a `Invalid Format`error, make sure your private key started with `-----BEGIN RSA PRIVATE KEY-----`and ends with `-----END RSA PRIVATE KEY-----`



#### Delete EC2 instance

- `--instance-ids`: Delete using instance ID

```
MY_EC2_NAME=ec2-uswest2-armand
MY_EC2_INSTANCE_ID=$(aws ec2 describe-instances \
	--filters "Name=tag:Name,Values=$MY_EC2_NAME" \
	--query 'Reservations[].Instances[].InstanceId' \
	--output text)
	
aws ec2 terminate-instances --instance-ids $MY_EC2_INSTANCE_ID
```





## Reference

- https://www.osradar.com/install-aws-cli-ubuntu-18-04/
- https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html
- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration-creds
- https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_create.html
- https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-sg.html
- https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html#launching-instances
- https://twpower.github.io/210-create-list-delete-ec2-instance-using-aws-cli-enx

