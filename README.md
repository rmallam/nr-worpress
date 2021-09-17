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
  
  ``` 
  kubectl create namespace wordpress
  helm repo add azure-marketplace https://marketplace.azurecr.io/helm/v1/repo
  helm install wordpress azure-marketplace/opencart -n wordpress
  
-  get ingress lb

```
kubectl get svc --namespace wordpress wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}"

- get password for wordpress

```
kubectl get secret wordpress -o jsonpath="{.data.wordpress-password}" -n wordpress | base64 --decode


### Types of agents

