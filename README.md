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
{"message":"Hello World"}