# Docker-Lab
In this lab you will learn some basic commands of Docker to help you understand how to operate Docker as a building block of Kubernetes.

Start by opening putty and logging into the ....

Let's clone a repository that will contain all the code for your labs

    cd

    git clone https://github.com/gortee/PKS-Lab

You can browse the the reposity by changing into the directory or by visiting the site.  (`cd PKS-Lab`)

Let's start with a simple container from docker hub (https://hub.docker.com/) that will ping google.com three times then exit

Run the following command:

    docker run -dit --name my_container alpine ash

![DockerOutput](https://github.com/gortee/pictures/blob/master/D1.png)

This will start a container called my_container running the alpine image with it's shell ash started.  Let's examine the command line:
-dit : d=detached i=interactive t=terminal session
--name : name of container for easy reference
alpine : image name from docker hub if not found locally https://hub.docker.com/_/alpine
ash : paramter to tell it to start the ash shell which gives us the potential of interactivity

We can see it as running and get it's container ID with the following command

    docker ps

![DockerOutput](https://github.com/gortee/pictures/blob/master/D2.png)

Now it's execute a ping inside this container.

    docker exec -it my_container ping -w3 google.com 
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/D3.png)

Let's examine this command line:
-it : i=interactive t=terminal
my_container : user friendly name
ping -w3 google.com : send three pings to google.com

Notice is has output to SDOUT
