# Docker And Kubernetes Series

## Why use docker

Briefly, because it makes it really easy to install and run software without worrying about setup or dependencies.

## What is docker

Docker is a platform or ecosystem contains a bunch of tools(e.g. Docker Client, Docker Server, Docker Machine, Docker Images, Docker Hub, Docker Compose) that comes together to to creating and running containers.

### What's the container

Briefly, when we run `docker run sth` this is what happening : Docker Cli reach to something named Docker Hub and download the **Image** contains the a bunch of configuration and dependencies to install and running a very specific program _the images file will store on hard drive_ and on some point of time you can use this image to create a container, so the container is an instance of image a we can look at as an running program, in other word a container is a program with it's own set of hardware resources that have it's own little space of memory it's own little space of networking and it's own little space of hard drive as well.

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

## Manipulating docker cli

### Create and running a container from an image

> docker run hello-world

Overriding default commands:

> docker run busybox ls

executing specified command in container

output:

```shell
.
..
.dockerenv
bin
dev
etc
home
proc
root
sys
tmp
usr
var
```

### List all running containers

> docker ps

List all the containers the have been created:

> docker ps --all

### Container life cycle

docker run = docker create + docker start -a

creating a container:

> docker create busy-box ls -a

create a container and return it's id:

```shell
bd9fb4cd2ae040fb9413be7368d7a693f8e83780f6dcde92a65d6f8570fc045089
```

> docker ps --all

output

```shell
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
bd9fb4cd2ae0        busybox             "ls -a"             12 seconds ago      Created                                 exciting_hodgkin

```

container is in **Created** STATUS

start the container with a watcher attached to it's output to print out on the terminal

> docker start -a bd9fb4cd2ae040fb9413be7368d7a693f8e83780f6dcde92a65d6f8570fc045089

output:

```shell
.
..
.dockerenv
bin
dev
etc
home
proc
root
sys
tmp
usr
var
```

> docker ps --all

output

```shell
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
bd9fb4cd2ae0        busybox             "ls -a"             3 minutes ago       Exited (0) 7 seconds ago                       exciting_hodgkin

```

container is in **Exited** STATUS

### Removing containers

Remove all stopped containers, all dangling images, and all unused networks:

> docker system prune

You’ll be prompted to continue, use the `-f` or `--force` flag to bypass the prompt.

Remove by CONTAINER_ID(s):

> docker container rm CONTAINER_ID_1 CONTAINER_ID_2

Remove all stopped containers:

> docker container prune

### Removing images

List of images

> docker images --all

Remove by IMAGE_ID(s):

> docker image rm IMAGE_ID

### Retrieving log output

> docker logs CONTAINER_ID

### Stop / kill container

> docker stop CONTAINER_ID

> docker kill CONTAINER_ID

Recommended docker stop to stop a process it will automatically run docker kill command if container not stop after 10 sec

### Executing command in a running container

> docker run redis

This command will create container and then start redis-server into it

> docker ps

output:

```shell
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
c7c021ce2637        redis               "docker-entrypoint.s…"   6 minutes ago       Up 6 minutes        6379/tcp            stupefied_lamport
```

> docker exec -it c7c021ce2637 redis-cli

The `-it` flag makes the container to receive input; without specifying this flag the process will start but don't let us to issue the inputs

### The it flag purpose

Every processes (in docker container) that running on linux environment have three communication channel attach to it:
this channels is using to communicate information either into the process or out of the process:

-   STDIN: Comminute information into the process
-   STDOUT: Convey information that coming out of the process
-   STDERR: Covey information out of the process that kinds of like errors

The `-it` flag is shorten of two separate`-i` and `-t` flag:

-   -i flags mean when we run this command we are going to attach or terminal to the STDIN channel of running process
-   -f briefly it make the out come texts show pretty(indent and etc)

## Getting a command prompt in a container

> docker exec -it 4aec7087de55 sh

`sh` is some kind of command shell program like bash, zsh or ... that allow us to issue command on terminal. Traditionally a lots of containers that your going to be workings with contains sh program

### Starting with a shell

> docker run -it busybox sh

## Building custom images through docker daemon

Here is the steps we gonna go through:

1.  setup Dockerfile: a plain text file that define how our **container** should behave in other word whats programs it contains and how it's behave when first startup
2.  pass the Dockerfile to dockerCli and dockerCli will pass to dockerDaemon
3.  dockerDaemon will look up to docker file and will create a **usable image** of it

### Building a Dockerfile

flow of crating a Dockerfile:

1. specify a base image
2. run some command to install additional programs
3. specify a command to run on container startup

./Dockerfile

```Dockerfile
# specify the base image
FROM alpine

# download and install additional programs
RUN apk add --update redis

# specify a command to run on container startup
CMD ["redis-server"]
```

> docker build .

> docker run ImageID

What's happening after running `docker build .`

1. dockerCli will pass DockerFile to dockerDaemon
2. dockerDaemon look at the localCash to find the `base image` (in our case alpine) then either download it or not from it's library
3. dockerDaemon will initialized the base image
4. when dockerDaemon is about to running the `RUN` command it will create a `intermediate container` from the base image (in our case alpine)
5. dockerDaemon will run the specified command into that intermediate container (in our case `apk add --update redis`) and take it file snapshot (the actual image or images that downloaded)
6. dockerDaemon removing the intermediate container
7. dockerDaemon will take the file snapshot and the starting command then make a temporary image of it

### tagging an Image

> docker build -t tajpouria/redis:latest .

> docker run tajpouria/redis

### Manual image generating with docker commit

> docker run -it alpine sh
> \#apk add --update redis

> docker commit -c '["redis-server"]' CONTAINER_ID
