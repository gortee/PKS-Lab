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


     
  
 
 
