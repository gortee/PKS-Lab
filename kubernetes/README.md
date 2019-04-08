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

# Services

Adding services is a key element to exposing services to the outside world.   We can do this via the services command set.  Remember you can expose services via NodePort, LoadBalancer or ClusterIP (internal only).   NSX-T provides the functionality to provision load balancers on demand as needed from the Kubernetes command line or API.   First examine the current services:

    kubectl get services
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K15.PNG)

It shows the loadbalancer currently provisioned for access to the Kubernetes API (master/etcd) (NAME: kubernetes TYPE: ClusterIP)

To create a LoadBalanced service for our deployment type the following command:

    kubectl expose deployment/bootcamp --type=LoadBalancer --port 8080
    
Let's review the services available now that we have created a new LoadBalancer for deployment/bootcamp:

   kubectl get services
   
![DockerOutput](https://github.com/gortee/pictures/blob/master/K16.PNG)

You now have a new LoadBalancer for bootcamp with the following information:
- Cluster-IP (internal) : 10.100.200.103 internal way to access the loadbalancer for c&c
- External-IP : 10.40.14.42,100.64.96.7 the first address is the external IP to access this service the second is a routing IP address.

Let's try accessing our deployment on your IP address (mine is 10.40.14.42) open the web browser and navigate to http://{your-external-ip:8080.   

![DockerOutput](https://github.com/gortee/pictures/blob/master/K17.PNG)

The tight integration between NSX-T and Kubernetes makes this possible.  Login to NSX manager by opening an additional tab in Chrome and clicking on the NSX-T Manager icon.  
- Username: admin
- Password: VMware1!

Once logged in:
- Click Load Balancers in middle of the screen
- Click on the Virtual Servers tab
- Review the list of virtual servers and locate the one called default-bootcamp (denotes that it's default namespace and called bootcamp service)   

Return to the cli-vm console.  For additional details on the bootcamp service use the following command:

    kubectl describe service bootcamp
   
![DockerOutput](https://github.com/gortee/pictures/blob/master/K18.PNG)

# Labels
Labels are metadata that allow you to group machines or apply policies dynamically.   Our deployment has a label assigned at creation time called run=bootcamp this is assigned to the pod, deployment & service.   You can see labels assigned to resources using the describe command.   Labels are in the form of designation=element for example version=1.  Let's get pods & services with the label.  

    kubectl get pods -l run=bootcamp

    kubectl get services -l run=bootcamp

![DockerOutput](https://github.com/gortee/pictures/blob/master/K19.PNG)

We can assign a label to a resource for example the service using this command syntax:

    kubectl label service bootcamp app=v1

Let's return all the services with this label:

    kubectl get services -l app=v1
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K20.PNG)

# Scale a deployment
Let's assume that at different times of the year your will need additional pods to service your requests.  This is handled very well by Kubernetes.  We have a external LoadBalancer that has awareness of the pods so we simply deploy additional pods.  In order to scale from one pod to 4 we issue the following command:

    kubectl scale deployments/bootcamp --replicas=4
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K21.PNG)

Looking at the deployment and pods we should now have additional replicas of the image:

    kubectl get pods
    
    kubectl get deployments 
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K22.PNG)

If you return to the NSX-T console in Chrome you can select the Service Pool tab to show the backend containers now included in the pool for the load balancer.  It clearly denotes 4 members.  Click on the 4 to see the pod names.   

![DockerOutput](https://github.com/gortee/pictures/blob/master/K23.PNG)

Go to the Chrome tab for your LoadBalancer service and reload to see if the pod name changes.  (It may not because it assigns you a pool member when first connection is established and does not change until session is ended)

Return to cli-vm. 

You can get detailed information on the four pods using this command:

    kubectl get pods -o wide
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K24.PNG)

Describing the service will show how each of the invidiual pods are now part of the service:

    kubectl describe service bootcamp

Scaling down is easy and non-interruptive as well using the following command we can scale down to 2 pods:

    kubectl scale deployments/bootcamp --replicas=2
    
You can track progress with this command:

    kubectl get pods
    
 ![DockerOutput](https://github.com/gortee/pictures/blob/master/K25.PNG)
 
 # Update the application
 One of the super powers of Kubernetes is the ability to update an application dynamically without interruption.  For this we will update the image to a new version without customer interruption (remember we have two pods).   
 
 Start by updating the image to be used by the deployment:
 
     kubectl set image deployments/bootcamp bootcamp=jocatalin/kubernetes-bootcamp:v2
     
 This will automatically update the image one at a time.  You will have to type the following commands fast to catch the state of the old containers.   
 
    kubectl get pods
    kubectl describe services/bootcamp
    kubectl rollout status deployments/bootcamp
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K26.PNG)   

Return to the web browser window for our application and reload to see the version change to v2

![DockerOutput](https://github.com/gortee/pictures/blob/master/K27.PNG)   

# Roll back the application
We can also rollback the V2 application to V1 very quickly.  

Set the image for the deployment:

    kubectl set image deployments/bootcamp bootcamp=gcr.io/google-samples/kubernetes-bootcamp:v1
    
Do the rollout command:

    kubectl rollout undo deployments/bootcamp

Check progress:

    kubectl get pods
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K28.PNG)   

# Desired state management
Kubenetes is an orchestrator as illustrated so far ensuring it meets our requirements it is also a desired state management tool.   In order to illustrate this we are going to delete a pod inside our deployment.   Remember that we set this deployment to have two pods you can see the desired state using this command:

    kubectl get service bootcamp
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/K29.PNG) 

We expect two pods.   Let's remove one of the pods:

    kubectl get pods

![DockerOutput](https://github.com/gortee/pictures/blob/master/K30.PNG) 

Select a name of a pod inside your list I am going to use bootcamp-f54cfd479-76ngz.  

    kubectl delete pod bootcamp-f54cfd479-76ngz

Let's see that pod get removed:

    kubectl get pods

![DockerOutput](https://github.com/gortee/pictures/blob/master/K31.PNG) 

As shown I now have a new pod automatically recreated by Kubernetes to satisfy my desired state of two pods (in my case bootcamp-f54cfd479-xfmsz is the new pod)  Just in case your wondering the new pod was added to the service / load balancer and the old pod was removed (unless it just took over the old IP address)


# Clean up 
Operating micro-services one command at a time is not normal for Kubernetes but has allowed us to step through operation.  Let's clean up the deployment and service.   

    kubectl delete service bootcamp
    kubectl delete deployment bootcamp

Over time this will remove all resources including pods.   (Yes the virtual server will be cleaned up as well).  

# WordPress
While Wordpress is not a micro-service it does allow us to show the power of Kubernetes.   One of the key challenges of the docker wordpress was the lack of persistent storage.   VMware implements storage persistence using Project Hatchway (https://vmware.github.io/hatchway/) this allows us to create a MySQL container with persistent storage.   This is critical if the container or worker node fails the storage will persist and be reconnected to the image recreated by Kubernetes as shown below:

![DockerOutput](https://github.com/gortee/pictures/blob/master/K32.PNG)

In this tutorial we will begin to work with much more complex constructs inside YAML files.   You can chain whole micro-services inside a single YAML file for ease of use.   The first thing we need to do is create a secret inside Kubernetes as the password for the database.  By using this method we avoid having hard coded passwords in the YAML files.  

    kubectl create secret generic mysql-pass --from-literal=password=YOUR_PASSWORD

Examine this command:
 - create secret : action
 - generic : type of password
 - mysql-pass : name of secret for reference in YAML
 - --from-literal=password=YOUR_PASSWORD  password is the variable and YOUR_PASSWORD is the password
 
 We can now create additional constructs using the kubectl create -f (-f for file) command.   We need to create a storage class inside Kubernetes that allows our YAML files to access project Hatchway.   Hatchway will dynamically create VMDK files on VMware cluster file system on demand.   In order to save you massive typing we are going to use the repository you downloaded:
 
    cd /root/PKS-Lab/kubernetes/wordpress
 
 We will be implementing the file storage_class.yaml which contains the following:
 
 ![DockerOutput](https://github.com/gortee/pictures/blob/master/K33.PNG)

