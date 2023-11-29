# python_api_sample

## Run DEV server : 
#### $ `python -m uvicorn main:app --reload`
## execute unit test cases
#### $ `python -m unittest test_main.py` 

## Run with Docker compose
####  $ `docker compose --env-file env up -d`
#### test the application endpoint with Curl
####  $ `curl localhost:8001`
####  $ `docker compose --env-file env down`


## To run with K8
#### $ `cd k8-deployment`

#### $ `kubectl apply -f deployment.yaml`

#### \$ `curl $(kubectl get ingress pythonfastapi-ingress -o jsonpath='{.status.loadBalancer.ingress[].ip}')`
"Hello World!"


## Docker installation
#### $ curl -fsSL https://get.docker.com | bash

##  kubectl Installation
#### \$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#### $ install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
#### $ kubectl version

## MiniKube Installation
#### $ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
#### $ sudo dpkg -i minikube_latest_amd64.deb
#### $ sudo sysctl fs.protected_regular=0
#### $ minikube start --driver=docker --force
#### $ minikube start --network-plugin=cni --cni=calico --force
#### $ minikube addons enable ingress
