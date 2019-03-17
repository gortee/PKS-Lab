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
-dit : d=detached i=interactive t=tty  this allows us to run commands in the container
--name : name of container for easy reference
alpine : image name from docker hub if not found locally https://hub.docker.com/_/alpine
ash : paramter to tell it to start the ash shell which gives us the potential of interactivity

We can see it as running and get it's container ID with the following command

    docker ps

![DockerOutput](https://github.com/gortee/pictures/blob/master/D2.PNG)

Now it's execute a ping inside this container.

    docker exec -it my_container ping -w3 google.com 
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/D3.PNG)

Let's examine this command line:
-it : i=interactive t=tty this allows us to run commands in the container
my_container : user friendly name
ping -w3 google.com : send three pings to google.com

Notice is has output from the ping is to standard out in otherwords outside the container.  This is a key element of 12 factor applications that logging and error should go to standard out.   Having some method to capture this output is critical.  

Let's review the network settings for our containers.  
   
    docker network ls
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/D4.PNG)

The output shows that we have four networks total each of these networks represents it's own routing domain.  Every container inside a specific network ID has the ability to communicate with each other.   The capability for a container to get outside it's own network is done via source NAT.  You can expose specific container ports on the docker host for external service exposure.   Lets examine the networking for my_container look specifically for the NetworkSettings section

    docker inspect my_container
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/D5.PNG)

As you can see the container has an assigned IP address with a gateway you should be able to ping this container from your docker host but not the outside world.  Trying pinging the container from your docker host looking for the IPAddress line (mine is 172.17.0.2)

    ping 172.17.0.2
    
You can end your ping with CTRL-C

![DockerOutput](https://github.com/gortee/pictures/blob/master/D6.PNG)

Let's now create a web server container that forwards container port 80 to docker host port 8080 (making port 80 on the container accessable on the real network)  For this we will use a ngnix container.  

    docker run -d -p 8080:80 --name my_web_server nginx
    
![DockerOutput](https://github.com/gortee/pictures/blob/master/D7.PNG)

Lets examine this command line
run : run a container
-d : detached 
-p 8080:80 : expose port 80 on the container via port 8080 on the docker host
--name my_web_server : user friendly name of container
nginx : docker hub image to use


