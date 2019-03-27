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

    kubectl get ns
    
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
  
  Once logged into the system locate the search bar at the top of the screen.
 
  Paste the UUID into the search bar and press enter to search.  
  
![DockerOutput](https://github.com/gortee/pictures/blob/master/P5.PNG)
 
 Click on the name logical routers tab
 
![DockerOutput](https://github.com/gortee/pictures/blob/master/P6.PNG)
  
 As you can see we have a logical router for each namespace and load balancers (lb)
 
 Switch back to the cli-vm and lets create a new namespace
 
     kubectl create ns development
     
 ![DockerOutput](https://github.com/gortee/pictures/blob/master/P7.PNG)
 
 Looking again in NSX-T on Chrome perform the search again and select logical routers
 
 You can see the creation of the development router for the development name space.
 
  ![DockerOutput](https://github.com/gortee/pictures/blob/master/P8.PNG)
 
 This automation is made possible via the NCP provider in Kubernetes.  Let's remove our namespace back on the cli:
 
     kubectl delete ns development
    
   ![DockerOutput](https://github.com/gortee/pictures/blob/master/P9.PNG)
 
 Return to the NSX-T console and see that the router for development has been automatically removed.  Using just Kubernetes constructs you can adjust networking on demand without knowledge of the networking constructs.  
 
 ![DockerOutput](https://github.com/gortee/pictures/blob/master/P10.PNG)
 
 
 If you have multiple clusters you can switch between them on the command line using 
 
     kubectl config use-context <cluster-name>

 
 The PKS command line essentially has only commands to create, update, delete Kubernetes clusters.   PKS commands are documented here:  https://docs.pivotal.io/runtimes/pks/1-3/managing-clusters.html 
 
 You can resize a cluster with a single command:
 
     kubectl resize my-cluster --num-nodes 4
     
 ![DockerOutput](https://github.com/gortee/pictures/blob/master/P11.PNG) 
 
 Log into vCenter in order to watch progress.  
 
 Go to Chrome open a new tab and select the folder RegionA and the bookmark for RegionA vCenter (https://vcsa-01a.corp.local/vsphere-client/?cs)  
  - Username: administrator@corp.local
  - Password: VMware1!
  
  Once logged in check recent tasks to see PKS in action.  The new additional worker node will be added to Region01->RegionA01-COMP01->pks-comp1.  As you can see in the attributes it is listed as a worker node.
  
![DockerOutput](https://github.com/gortee/pictures/blob/master/P12.PNG) 
 
 You can also check the status of this resize via the cli by running:
 
     pks cluster my-cluster
     
![DockerOutput](https://github.com/gortee/pictures/blob/master/P13.PNG)

Continue with the lab we will check back on this later in the lab.
  
  
 
 # Interacting with Bosh and PKS
     
  
 
 
 
 #Checking on resizing
 
 Lets check on our resizing operation using the pks command line
 
     pks cluster my-cluster
     
      
![DockerOutput](https://github.com/gortee/pictures/blob/master/P14.PNG)

Resize it back to three nodes

    pks resize my-cluster --num-nodes 3
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/P15.PNG)

You can monitor it via the 

    pks cluster my-cluster 
   
![DockerOutput](https://github.com/gortee/pictures/blob/master/P16.PNG)

You can see it was deleted in vCenter as well

![DockerOutput](https://github.com/gortee/pictures/blob/master/P17.PNG)
