# Kubernetes-Lab 
# Basic Kubernetes

Login to the cli-vm

See available clusters

    pks clusters

Get credentials for my-cluster

    pks get-credentials my-cluster


![DockerOutput](https://github.com/gortee/pictures/blob/master/K1.PNG)

Review the worker nodes for PKS cluster my-cluster

    kubectl get nodes
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K2.PNG)
 
This displays basic data on the worker nodes.  
