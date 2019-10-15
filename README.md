# Docker And Kubernetes Series

## Why use docker

Briefly, because it makes it really easy to install and run software without worrying about setup or dependencies.

## What is docker

Docker is a platform or ecosystem contains a bunch of tools(e.g. Docker Client, Docker Server, Docker Machine, Docker Images, Docker Hub, Docker Compose) that comes together to to creating and running containers.

### What's the container

Briefly, when we run <mark>docker run sth</mark> this is what happening : Docker Cli reach to something named Docker Hub and download the **Image** contains the a bunch of configuration and dependencies to install and running a very specific program _the images file will store on hard drive_ and on some point of time you can use this image to create a container, so the container is an instance of image a we can look at as an running program, in other word a container is a program with it's own set of hardware resources that have it's own little space of memory it's own little space of networking and it's own little space of hard drive as well.

## Docker for windows/mac

Contains:

-   Docker Client (Docker CLI)
    Tool that we are going to issue commands to
-   Docker Server (Docker Daemon)
    Tool that is responsible for creating images, running containers and etc

## Installing Docker Engine - Community and Docker-Compose

If you wish, Docker can also be installed on many different types of Linux distributions. This note covers how to install with Ubuntu, but the Docker docs have instructions for CentOS, Debian and Fedora as well.

Installation

_Note_: These steps were successfully completed with Ubuntu Desktop 18 LTS

The docs for Ubuntu installation suggest setting up a Docker repository to install and update from.

This is where you should start:

https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository

After completing the installation steps, test out Docker:

sudo docker run hello-world

This should download and run the test container printing "hello world" to your console.

Installing Docker Compose

Unlike the Mac and Windows Docker Desktop versions, we must manually install Docker Compose. See the instructions for the installation steps (Click on the tab for Linux)

https://docs.docker.com/compose/install/#install-compose

After completing, test your installation:

docker-compose -v

This should print the version and build numbers to your console.

Run without Sudo

Follow these instructions to run Docker commands without sudo:

https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user

The docker group will likely already be created, but you still need to add your user to this group.

Start on Boot

Follow these instructions so that Docker and its services start automatically on boot:

https://docs.docker.com/install/linux/linux-postinstall/#configure-docker-to-start-on-boot

You may need to restart your system before starting the course material.

## Using the docker client

> docker run hello-world

What just happened when we run this command:

1. we run the command `docker run hello-world` on docker cli (that mean we gonna run a container with an image named hello-world)
2. docker cli issue to docker daemon (server)
3. docker daemon check to see if we have a local copy of hello-world image on some thing called **Image Cache**
4. if hello-world image does not exist on image cache docker daemon will reach out to some free service named **Docker Hub** (the repository of free images that we can download an install)
5. docker daemon will download hello-world image and store it on image cache _then we can install and rerun it later without reaching to docker hub_
6. then docker server took that single file, load it on the memory to create a container of it run the program inside of it
7. then hello-world program will run in the container and it's whole purpose is to print some text on the terminal
