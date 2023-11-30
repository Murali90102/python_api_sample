## Java installation in Ubuntu:
sudo apt update
sudo apt install openjdk-11-jre
java -version

###########################################################################

## Jenkins Installation:
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins		

###########################################################################

# python_api_sample

## Run DEV server : 
#### $ `python -m uvicorn main:app --reload`
## execute unit test cases
#### $ `python -m unittest test_main.py` 

###########################################################################

## Kubernetes installation and configuration
#Kube-Master(Controller)  - VM 
#	Kube-Worker1
#	Kube-Worker2  -> pod 

#https://kubernetes.io/docs/setup/
	
#Add Port: 0 - 65535
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
###On Both Master and Worker Nodes:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sudo -i

yum update -y

swapoff -a
#The Kubernetes scheduler determines the best available node on which to deploy newly created pods. If memory swapping is allowed to occur on a host system, this can lead to performance and stability issues within Kubernetes.

setenforce 0
#Disabling the SElinux makes all containers can easily access host filesystem.

yum install docker -y

systemctl enable docker 
systemctl start docker

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF


cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

yum install -y kubeadm-1.21.3 kubelet-1.21.3 kubectl-1.21.3 --disableexcludes=kubernetes 

systemctl enable kubelet 
systemctl start kubelet

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Only on Master Node:
#~~~~~~~~~~~~~~~~~~~~~
#Update Master_Private IP in --apiserver-advertise-address=172.31.33.90

sudo kubeadm init --apiserver-advertise-address=172.31.34.145 --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#export KUBECONFIG=/etc/kubernetes/kubelet.conf 
  
#We need to install a flannel network plugin to run coredns to start pod network communication.

sudo kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml 
sudo kubectl apply -f https://docs.projectcalico.org/v3.8/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml 

#Test the configuration ::

kubectl get pods --all-namespaces

#Generate NEW Token :
kubeadm token create --print-join-command

kubectl get nodes

kubectl describe nodes


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Execute the below commmand in Worker Nodes, to join all the worker nodes with Master :
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


kubeadm join 172.31.33.90:6443 --token rri13u.fs9vu2hknzhfrnvs --discovery-token-ca-cert-hash sha256:044883f8a587ac31aa7ce906aa44835bde8e61cc3a66dd35286e49dcffbad7b7

##########################################################################################################################################################################

## To run with K8
#### $ `cd k8-deployment`

#### $ `kubectl apply -f deployment.yaml`

"Hello World!"


## Docker installation
#### $ curl -fsSL https://get.docker.com | bash
#### sudo mod -aG docker jenkins

##### Prometheus and Grafana Installation and Configuration

Please refer the installation file

