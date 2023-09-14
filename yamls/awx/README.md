Step 1: Deploy Kubernetes Cluster 
Step 2: Deploy MetalLB / Ingress solution
Step 3: Configure Persistent Storage Solution
Step 4: Deploy AWX Operator on Kubernetes 
    ### Ubuntu / Debian ###
          sudo apt update
          sudo apt install git build-essential curl jq  -y

    ### RHEL based systems ###
          sudo yum -y install epel-release
          sudo yum group install "Development Tools"
          sudo yum install curl jq
Step 5:  git clone https://github.com/ansible/awx-operator.git
          export NAMESPACE=awx
          kubectl create ns ${NAMESPACE}
          kubectl config set-context --current --namespace=$NAMESPACE 
          cd awx-operator/
          RELEASE_TAG=`curl -s https://api.github.com/repos/ansible/awx-operator/releases/latest | grep tag_name | cut -d '"' -f 4`
          echo $RELEASE_TAG
          git checkout $RELEASE_TAG
          export NAMESPACE=awx
          make deploy
Step 6:  kubectl create -f awx_pv.yaml
          kubectl create -f awx_pvc.yaml
          kubectl apply -f awx-deployment.yml
Step 7:   Check status
          kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator" -w
