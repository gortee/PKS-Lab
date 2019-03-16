# Docker-Lab
In this lab you will learn some basic commands of Docker to help you understand how to operate Docker as a building block of Kubernetes.

Start by opening putty and logging into the 

Let's start with a simple container from docker hub (https://hub.docker.com/) that will ping google.com three times then exit

Run the following command:

`docker exec -it my_container ping -w3 google.com`

The output from this command should look something like this:


If you examine this command you learn a few things
