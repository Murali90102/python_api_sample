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
#Kube-Master(Controller)
#	Kube-Worker1
#	Kube-Worker2

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
##### Update Master_Private IP in --apiserver-advertise-address=172.31.33.90

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

#Install Prometheus & Grafana :

### Goto https://prometheus.io/download/

https://github.com/prometheus/prometheus/releases/download/v2.45.0-rc.0/prometheus-2.45.0-rc.0.linux-amd64.tar.gz

wget https://github.com/prometheus/prometheus/releases/download/v2.38.0/prometheus-2.38.0.linux-amd64.tar.gz

tar -zxvf prometheus-2.38.0.linux-amd64.tar.gz

###===> Create following file:

sudo vi /etc/systemd/system/prometheus.service
#-------------------------------------------------------------------------

[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=root
Restart=on-failure

ExecStart=/root/prometheus-2.38.0.linux-amd64/prometheus --config.file=/root/prometheus-2.38.0.linux-amd64/prometheus.yml

[Install]
WantedBy=multi-user.target

#-------------------------------------------------------------------------

sudo systemctl daemon-reload
sudo systemctl status prometheus
sudo systemctl start prometheus

<prometheus-external-ip>:9090
http://13.232.192.132:9090/

####***********************************************************************


#Install Grafana :

### Goto https://grafana.com/grafana/download

###select OSS Edition.
#Choose Linux

##  Linux Distribution :

Red Hat, CentOS, RHEL, and Fedora(64 Bit)SHA256: 

wget https://dl.grafana.com/oss/release/grafana-9.1.2-1.x86_64.rpm

sudo yum install grafana-9.1.2-1.x86_64.rpm


sudo /bin/systemctl enable grafana-server.service
sudo /bin/systemctl start grafana-server.service
sudo /bin/systemctl status grafana-server.service

<grafana-external-ip>:3000
http://13.232.192.132:3000/

default user name & password : admin & admin


###*********************************************************************

###Install Node Exporters:

### Goto https://prometheus.io/download/

## Search for Node Exporter:
##Copy Link Linux address
### https://github.com/prometheus/node_exporter/releases/download/v1.4.0-rc.0/node_exporter-1.4.0-rc.0.linux-amd64.tar.gz


###Goto the server you wish to monitor and install Node Exporter :

wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0-rc.0/node_exporter-1.4.0-rc.0.linux-amd64.tar.gz


tar -zxvf node_exporter-1.4.0-rc.0.linux-amd64.tar.gz

###===> Create following file:

sudo vi /etc/systemd/system/node_exporter.service
#-------------------------------------------------------------------------

[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=root
Restart=on-failure

ExecStart=/root/node_exporter-1.4.0-rc.0.linux-amd64/node_exporter

[Install]
WantedBy=multi-user.target

#-------------------------------------------------------------------------

sudo systemctl daemon-reload
sudo systemctl status node_exporter
sudo systemctl start node_exporter

hostname

hostname -i

### copy the IP Address of the server you wish to monitor

## Goto to Prometheus Server ::

### installation path 
cd /root/prometheus-2.38.0.linux-amd64

vi prometheus.yml
## Add the target with valid node_exporter port as mentioned below:

- targets: ["172.31.7.77:9100"]


## Restart Prometheus:

sudo systemctl restart prometheus
sudo systemctl status prometheus

###Goto Prometheus server :

<prometheus-external-ip>:9090
http://13.232.146.141:9090/

## in the query field type up and click on execute to see the list of servers up for monitoring


##*******************************************************************************************************

###Create Prometheus Data Source in Grafana

###Goto Grafana 

##<grafana-external-ip>:3000
##http://13.232.146.141:3000/

Click on settings button --> Data Source --> Add Data Source --> Select Prometheus

http://13.127.218.51/:9090/

http://43.204.38.168:9090/

Enter in the Name field as Prometheus
Enter in the url field as the prometheus-server url with port eg.: <prometheus-external-ip>:9090 | http://13.232.146.141:9090/

Click on Save & Test --- for Data Source is working 
Click on Back Button
See the Prometheus Data Source Created 

