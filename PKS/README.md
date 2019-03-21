# PKS-Lab
 
The first step is to login to the PKS CLI and issue a command to create a Kubernetes cluster.   

Login to the cli-vm by using putty and selecting cli-vm  

Once logged into the server via ssh issue the following command to login to PKS CLI

    pks login -a pks.corp.local -u pksadmin --skip-ssl-validation

 - Password: VMware1!

Check for any existing servers

    pks clusters
    
We can view the available plans (starting sizing of clusters) to PKS 

    pks plans

We will review the plan details post starting the deployment of a cluster

Deploy a small cluster with the following command:

    pks create-cluster my-cluster --external-hostname my-cluster.corp.local --plan small
  
Breaking the command line down we have
 - create-cluster : pks command to execute
 - my-cluster : reference name of the cluster (user friendly name for reference with future commands)
 - external-hostname : DNS hostname to reach the cluster (preloaded into DNS in our case)
 - plan : sets the plan for the initial deployment
 
 The creation of your cluster will take a few minutes while you wait for the cluster to deploy grab some lunch you can check the status of your deployment with this command
 
     pks clusters my-cluster

# Continue when cluster is listed as succeeded  

#Learning PKS

Login to the cli-vm

See available clusters

    pks clusters

Get my-cluster credentials 

    pks get-credentials my-cluster
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/P1.PNG)


List all namespaces on your cluster

    pks get ns
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/P2.PNG)

As you can see we have the four originally created name spaces
 - default
 - kube-public
 - kube-system
 - pks-infrastructure
 
 Each of these namespaces have their own NSX-T router to ensure logical seperation.  Let's examine this connection by logging into NSX-T.  
 
 First we need the UUID of the cluster
 
    pks clusters
 
 ![DockerOutput](https://github.com/gortee/pictures/blob/master/P3.PNG)
 
 Copy the UUID from the output 
 
 Open Chrome & Click the bookmark for NSX-T Manager
 
 Login to NSX-T
  - Username: admin
  - Password: VMware1!
  
  Once logged into the system click the magnafying glass at the top right side of the screen.
  
![DockerOutput](https://github.com/gortee/pictures/blob/master/P4.PNG)
   
  Paste the UUID into the search bar and wait for the search to begin to return results
  
![DockerOutput](https://github.com/gortee/pictures/blob/master/P5.PNG)
 
 Click on the name logical routers & expand out the Name from the search results as shown below
 
![DockerOutput](https://github.com/gortee/pictures/blob/master/P6.PNG)
  
 As you can see we have a logical router for each namespace and load balancers (lb)
 
 Switch back to the cli-vm and lets create a new namespace
 
     kubectl create ns development
     
 ![DockerOutput](https://github.com/gortee/pictures/blob/master/P7.PNG)
 
 Looking again in NSX-T on Chrome perform the search again and select logical routers
 
 You can see the creation of the development router for the development name space.
 
  ![DockerOutput](https://github.com/gortee/pictures/blob/master/P8.PNG)
 
 
     
  
 
 
