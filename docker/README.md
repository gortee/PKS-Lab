# Docker-Lab
In this lab you will learn some basic commands of Docker to help you understand how to operate Docker as a building block of Kubernetes.

Start by opening putty and logging into the ....

Let's clone a repository that will contain all the code for your labs

    cd

    git clone https://github.com/gortee/PKS-Lab

You can browse the the reposity by changing into the directory or by visiting the site.  (`cd PKS-Lab`)

Let's start with a simple container from docker hub (https://hub.docker.com/) that will ping google.com three times then exit

Run the following command:

    docker exec -it my_container ping -w3 google.com

The output from this command should look something like this:

![DockerOutput](https://github.com/gortee/pictures/blob/master/D1.png)

If you examine this command you learn a few things 

exec : tells us to execute a command inside the container
-it : i = interactive t = tty terminal this gives us a interactive terminal
my_container : container name
