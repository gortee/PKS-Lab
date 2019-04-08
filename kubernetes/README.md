# Kubernetes-Lab 
# Basic Kubernetes

Login to the cli-vm by using putty and selecting cli-vm  

Once logged into the server via ssh issue the following command to login to PKS CLI

    pks login -a pks.corp.local -u pksadmin --skip-ssl-validation

 - Password: VMware1!

See available clusters

    pks clusters

Get credentials for my-cluster

    pks get-credentials my-cluster


![DockerOutput](https://github.com/gortee/pictures/blob/master/K1.PNG)

You can switch between clusters using the suggested commands if you have multiple K8 clusters.  

Review the worker nodes for PKS cluster my-cluster

    kubectl get nodes
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K2.PNG)
 
This displays basic data on the worker nodes.  

You can gather additional data on a specific node by cutting and pasting it's name and running the following command (in my case I did node 58fb66e9-b305-4670-bdb3-21a00bdedc82):

    kubectl describe nodes {name}
    
 ![DockerOutput](https://github.com/gortee/pictures/blob/master/K3.PNG)
 ![DockerOutput](https://github.com/gortee/pictures/blob/master/K4.PNG)
 
 We are going to use a container provided by google to test the functionality of Kubernetes.  These steps will be very similar to docker commands we did before.   The image we will use is called kubernetes-bootcamp there are many different tutorials using this image available on the internet.  
 
    kubectl run bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1 --port=8080

![DockerOutput](https://github.com/gortee/pictures/blob/master/K5.PNG)

Looking at this command line we have:
- run : run a container
- bootcamp : name of deployment
- --image : url of image with version
- --port : port to expose on the container

We just created a deployment called bootcamp you can view it's current information via:

    kubectl get deployments
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K6.PNG)

We can get additional details using the describe command:

    kubectl describe deployment bootcamp
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K7.PNG)

Let's examine the other kubernetes constructs.  Namespace first

    kubectl get namespace
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K8.PNG)

Let's get details on the default namespace:

    kubectl describe namespace default 
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K9.PNG) 

Time to review the pods:

    kubectl get pods
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K10.PNG) 

You can see we have a bootcamp pod running let's get more details on the pod (in my case it's pod bootcamp-95bd888fc-pc2pq)

    kubectl describe pod {pod-name}
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K11.PNG)

This shows a lot of information on the pod (not individual image)  for example labels (metadata assigned) IP address of the pod and how the image was created.   Let's try to ping the IP address for the pod on the NSX-T overlay network. (in my case it was assigned 172.16.0.2) 

    ping -c 3 {ip_Address}
    
 ![DockerOutput](https://github.com/gortee/pictures/blob/master/K12.PNG)
 
 Let examine the logs from the pod using your pod name (mine is bootcamp-95bd888fc-pc2pq)
 
     kubectl logs {pod_name}
     
![DockerOutput](https://github.com/gortee/pictures/blob/master/K13.PNG)
 
 Running a command inside a container is very similar to Docker using the exec command for example lets get all the environment variables from our container using the env command:
 
     kubectl exec {pod_name} env
     
![DockerOutput](https://github.com/gortee/pictures/blob/master/K14.PNG)

Adding services is a key element to exposing services to the outside world.   We can do this via the services command set.  Remember you can expose services via NodePort, LoadBalancer or ClusterIP (internal only).   NSX-T provides the functionality to provision load balancers on demand as needed from the Kubernetes command line or API.   To create a LoadBalanced service for our deployment type the following command:


 
