# nr-worpress
### Table of Contents
- [nr-worpress](#nr-worpress)
    - [Table of Contents](#table-of-contents)
    - [Introduction](#introduction)
    - [Environment](#environment)
    - [installation](#installation)
    - [Types of agents](#types-of-agents)

### Introduction

This document speaks about various New-Relic agents and describes the process of installing and using them in real time environment.

### Environment

| Cloud Provider  | Platform |Application |
| ----------------| ----------- |----------| 
|   Azure         | Azure Kubernetes Service| bitmani open cart  |

### installation

- **Aks Cluster installation**
  ```
  az login
  az account set --subscription "SUBSCRIPTION-NAME"
  az group create --name aks-resource-group --location australiasoutheast
  az aks create --name aks-cluster --resource-group aks-resource-group --node-count 1 --generate-ssh-keys
  az aks get-credentials --name aks-cluster --resource-group aks-resource-group

- Install bitmani opencart
  
```s
  kubectl create namespace wordpress
  helm repo add azure-marketplace https://marketplace.azurecr.io/helm/v1/repo
  helm install wordpress azure-marketplace/opencart -n wordpress
```
  
-  get ingress lb

```s
kubectl get svc --namespace wordpress wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}"
```

- get password for wordpress

```s
kubectl get secret wordpress -o jsonpath="{.data.wordpress-password}" -n wordpress | base64 --decode
```

![alt text](https://github.com/rmallam/nr-worpress/blob/main/worpress.png?raw=true)

![alt text](https://github.com/rmallam/nr-worpress/blob/main/wploggedin.png?raw=true)

### Types of agents

- **Infrastructure agent/Kuberentes integration**


```s
kubectl apply -f https://raw.githubusercontent.com/pixie-labs/pixie/main/k8s/operator/crd/base/px.dev_viziers.yaml 
kubectl apply -f https://raw.githubusercontent.com/pixie-labs/pixie/main/k8s/operator/helm/crds/olm_crd.yaml 
helm repo add newrelic https://helm-charts.newrelic.com  helm repo update
kubectl create namespace aks ; helm upgrade --install newrelic-bundle newrelic/nri-bundle \
 --set global.licenseKey=licencehere \
 --set global.cluster=aks \
 --namespace=aks \
 --set newrelic-infrastructure.privileged=true \
 --set ksm.enabled=true \
 --set prometheus.enabled=true \
 --set kubeEvents.enabled=true \
 --set logging.enabled=true \
 --set newrelic-pixie.enabled=true \
 --set newrelic-pixie.apiKey=px-api-c590d8b0-3ff5-4c05-a4de-843a2a0ebc92 \
 --set pixie-chart.enabled=true \
 --set pixie-chart.deployKey=px-dep-5b8ee5f2-557a-404e-80fa-63122305a420 \
 --set pixie-chart.clusterName=aks 
 ```

![alt text](https://github.com/rmallam/nr-worpress/blob/main/newrelicaks.png?raw=true)

![alt text](https://github.com/rmallam/nr-worpress/blob/main/newrelicaks2.png?raw=true)

- Application agent
  
  1. Update the docker image to include the php agent and deamon 
     Refer to [dockerfile](dockerfile)
  2. Update the wordpress deployment with this new image
      ```s
      docker build -t mallam/nrwordpress:3.0.0 .
      docker push mallam/nrwordpress:3.0.0
      kubectl set image deployment/nginx-deployment wordpress=nrwordpress:3.0.0 --record
      ```


  ![alt text](https://github.com/rmallam/nr-worpress/blob/main/phpappnr.png?raw=true)
   

- Browser Agent
   
   1. Navigate to New relic UI and select browser agent tab
   2. Follow the on screen instructions to configure the browser agent to PHP applcation

  ![alt text](https://github.com/rmallam/nr-worpress/blob/main/browseragent.png?raw=true)