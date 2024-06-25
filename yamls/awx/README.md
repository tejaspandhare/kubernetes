# Deploying AWX on Kubernetes

This guide provides step-by-step instructions to deploy AWX (Ansible Tower) on a Kubernetes cluster.

## Step 1: Deploy Kubernetes Cluster

Ensure you have a Kubernetes cluster up and running.

## Step 2: Deploy MetalLB / Ingress solution

Set up MetalLB or any Ingress controller suitable for your Kubernetes environment.

## Step 3: Configure Persistent Storage Solution

Configure persistent storage as required by AWX.

## Step 4: Deploy AWX Operator on Kubernetes

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install git build-essential curl jq -y

# For RHEL based systems

sudo yum -y install epel-release
sudo yum group install "Development Tools"
sudo yum install curl jq

###Clone the AWX Operator repository:

git clone https://github.com/ansible/awx-operator.git
export NAMESPACE=awx
kubectl create ns ${NAMESPACE}
kubectl config set-context --current --namespace=$NAMESPACE
cd awx-operator/
RELEASE_TAG=$(curl -s https://api.github.com/repos/ansible/awx-operator/releases/latest | grep tag_name | cut -d '"' -f 4)
git checkout $RELEASE_TAG
export NAMESPACE=awx
make deploy

## **Step 5: Create Persistent Volumes and Deployments**

kubectl create -f awx_pv.yaml
kubectl create -f awx_pvc.yaml
kubectl apply -f awx-deployment.yml

 ## **Step 6: Check Deployment Status**

kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator" -w



