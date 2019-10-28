# Docker

## Why use docker

Briefly, because it makes it really easy to install and run software without worrying about setup or dependencies.

## What is docker

Docker is a platform or ecosystem contains a bunch of tools(e.g. Docker Client, Docker Server, Docker Machine, Docker Images, Docker Hub, Docker Compose) that comes together to to creating and running containers.

### What's the container

Briefly, when we run `docker run sth` this is what happening : Docker Cli reach to something named Docker Hub and download the **Image** contains the a bunch of configuration and dependencies to install and running a very specific program _the images file will store on hard drive_ and on some point of time you can use this image to create a container, so the container is an instance of image a we can look at as an running program, in other word a container is a program with it's own set of hardware resources that have it's own little space of memory it's own little space of networking and it's own little space of hard drive as well.

## Docker for windows/mac

Contains:

- Docker Client (Docker CLI)
  Tool that we are going to issue commands to
- Docker Server (Docker Daemon)
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

running and starting on the background

> docker run -d busybox

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

- STDIN: Comminute information into the process
- STDOUT: Convey information that coming out of the process
- STDERR: Covey information out of the process that kinds of like errors

The `-it` flag is shorten of two separate`-i` and `-t` flag:

- -i flags mean when we run this command we are going to attach or terminal to the STDIN channel of running process
- -f briefly it make the out come texts show pretty(indent and etc)

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

What's happening after running `docker build .` _dot( . ) means the build context of the container_

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

## Building a simple server with docker

./Dockerfile

```Dockerfile
# install node baseImage with alpine tag tie to it
FROM node:alpine

# specifying a working directory for application
WORKDIR /usr/simpleServer

# copy file(s) from [ path relative to building context ] to [ path into container relative to WORKDIR ]
COPY ./package.json ./

RUN npm i

# separating COPY command because we don't want to reinstall all the dependencies after changing to source files
COPY ./ ./

CMD ["npm", "start"]
```

### Container port mapping

> docker run -p 4000:8080 IMAGE_ID/NAME

That's mean anytime that a request comes to port 8080 of `my machine` redirect it to port 8080 `inside the container`

## Docker compose with multiple local containers

### Docker compose

docker-compose is a separate cli installed with docker, used to start up multiple docker containers at the same time, automates some of the long-winded arguments we were passing to `docker run`

### docker-compose.yml

`docker-compose.yml` contains all the options we'd normally pass to docker-cli

with this knowledge as an instance here is the containers we gonna create:

- redis-server: make it using redis image

- visits-server: make it using Dockerfile then connect it's port to local machine

./docker-compose.yml

```yml
# the version of docker-compose
version: "3"
# type of containers
services:
  redis-server:
    image: "redis" # use this image to build this container
  visits-server:
    build: . # build this container using Dockerfile in this directory
    ports:
      - "4000:8080" # map [local machine port]:[container port]
```

then we can us it connect our server to redis-container

./index.ts

```typescript
const redisClient = redis.createClient({
  host: "redis-server", // docker parse as an url
  port: 6379
});
```

./Dockerfile

```Dockerfile
FROM node:alpine

WORKDIR /usr/visits-server

COPY ./package.json .

RUN npm i

COPY . .

CMD ["npm", "start"]

```

### docker-compose commands

- docker run myImage:

> docker-compose up

> docker-compose up -d

- docker build . & docker run myImage **use when make change in images**

> docker-compose up --build

- docker stop CONTAINER_ID

> docker-compose down

- docker ps
  > docker-compose ps

### Container maintenance with compose

### Restart policies

- **"no"**`( default )`: never attempts to restart this . container if it stops or crashes

- **always**: if this container stops `always` attempt to restart it

- **on-failure**: only restart the container stops with an `error code`

- **unless-stopped**: always restart unless we forcibly stop it _on cli_

_just "no" have quote in yml files no will interpreted as false_

./docker-compose.yml

```yml
version: "3"
services:
  visits-server:
    restart: always
```

## A productions grade workflow

[Following description project repository](https://github.com/tajpouria/Docker-Travis-Test)

The process of development, testing and deployment and eventually on some point of time doing some additional development, additional testing and redeploy the application

### A development image

./Dockerfile.dev

```Dockerfile
FROM node:alpine

WORKDIR /usr/react-app

COPY ./package.json .

RUN npm i

COPY . .

CMD ["npm", "run", "start"]
```

build Dockerfile with custom name using `-f` flag:

> docker build -f Dockerfile .

### Docker volumes

With a dockerVolume we essentially setup some placeholder of sorts inside our container and instead of copy files we reference that file to the actual container in other word we mapping a folder inside a container to a folder outside a container

using `-v` flag you can either bookmark a file or map it, for example in following command:

_in following make sure the paths are absolute_

> docker run -p 3000:8080 -v /usr/react-app/node_modules/ -v \$(pwd):/usr/react-app/ IMAGE_ID

- node_modules `book marked` means do not map this file with an external file
- and other files in **present working directory(pwd)** are mapped(referenced) to external files and folders

### Shorthand with docker-compose

./docker-compose.yml

_the paths has to absolute_

```yml
version: "3"
services:
  react-app:
    build: # specify costume named docker file to build
      context: .
      dockerfile: Dockerfile.dev # dockerfile spelling
    ports:
      - "3000:8080"
    volumes:
      - "/usr/rect-app/node_modules" # bookmark
      - ".:/usr/react-app" # reference
```

### Live updating tests

Here is two diffrend approach to run our tests

- attach the running container:

> docker exec -it IMAGE_ID npm run test

- docker-compose

```yml
version: "3"
services:
  # rect-app ...
  tests:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - "usr/react-app/node_modules"
      - ".:/usr/rect-app"
    command: ["npm", "run", "test"] # overriding startup command
```

is it any way to interact with test service:

after running sh on container that is network between react-app and tests:

- > \# ps

output:

```shell
PID   USER     TIME  COMMAND
    1 root      0:00 npm
   17 root      0:00 node /usr/react-app/node_modules/.bin/react-scripts start
   24 root      0:05 node /usr/react-app/node_modules/react-scripts/scripts/start.js
  130 root      0:00 sh
  136 root      0:00 ps

```

as you see the primary process that is going on in this container with PID 1, but the problem is after running `docker attach CONTAINER_ID` it will automatically attach to primary process but for interacting to tests process we need to connect to start.js with PID of 24

### A production image

### Multi-step docker process

Using this feature when we're gonna have multi blocks of configuration for instance in our application we're gonna have two block of configuration:

1. build phase purpose:

- using node:alpine
- copy package.json
- install dependencies
- run npm run build

2. run phase purpose:

- use nginx
- copy over the results of npm run build **(essentially all the we copy the build folder and the other stuff like(node:alpine, node_modules and etc) drop from the result container)**
- start nginx

./Dockerfile

```Dockerfile
# tag the stage as builder
FROM node:alpine as builder
WORKDIR /usr/react-app
COPY ./package.json .
RUN npm i
COPY . .
RUN npm run build
# the build folder we create at usr/react-app

FROM nginx
# putting EXPOSE 80 like this do nothing automatically in most environment (e.g. development environment) and is some kind of communication of sorts between developers to understand it container needs to some port mapped to port 80 but aws elastic beans talks will look for this EXPOSE and mapped it automatically
EXPOSE 80
# copy build folder from builder stage into user/share/nginx/html and nginx will automatically serve it when startup
COPY --from=builder /usr/react-app/build usr/share/nginx/html
# nginx will automatically set start command
```

> docker build .

_nginx default port is `80`_

> docker run -p 8080:80 CONTAINER_ID

## Continues integration

### Travis yml file configuration

Here is the steps we're gonna put in this file

- tell the travis we need a copy of docker running to build the project and running the tests suits
- build the project using the Dockerfile.dev (cuz the our Dockerfile not contains dependencies to run tests)
- tell the travis how to run the test suits
- tell the travis how to deploy our project over to aws

.travis.yml

```yml
# any time we use the docker we need to have super user permission
sudo: required

# we need a copy of docker
services:
  - docker

# gonna have a series of different command that get executed before another process (in our case before the tests run)
before_install:
  - docker build -t tajpouria/docker-travis-test -f dockerfile.dev .
# commands to run our tests suits
# travis CI is gonna watch out the output of each of this command: if one of the scripts return exit with status code except 0 the travis gonna assume that the test suit is actually failed and our code is essentially broken
# *** default behavior of npm run test is to hangout with output and not exit automatically so the travis will never gonna receive the exit status code we can exit the test after running it by specifying -- --watchAll=false flag
script:
  - docker run tajpouria/docker-travis-test npm run test -- --watchAll=false

deploy:
  provider: elasticbeanstalk
  region: "us-east-1"
  app: "react-docker"
  env: "Docker-env"
  bucket_name: "elasticbeanstalk-us-east-1-746123612876210"
  bucket_path: "react-docker"
  on:
    branch: master
  access_key_id: $AWS_ACCESS_KEY
  secret_access_key:
    secure: "$AWS_SECURE_KEY"
```

## A Multi Container Application

[Following description project repository](https://github.com/tajpouria/Docker-Multiple-Container-Test)

### docker-compose environment variables

this is gonna set up a variable inside the container at **run-time** of the container:

- `variableName=value`
- `variableName` the value is taken from machine

docker-compose.yml

```yml
version: "3"
services:
  postgres:
  restart: "always"
  build:
    dockerfile: Dockerfile.dev
    context: ./postgres
  environment:
    - "FILLA_DB_USER=docker"
    - "FILLA_DB_PASSWORD=postgres_password"
    - "FILLA_DB_DATABASE=multi_docker"
  redis:
    image: "redis:latest"
  nginx:
    restart: always
    build:
      dockerfile: dockerfile.dev
      context: ./nginx
    ports:
      - "3000:80"
  api:
    build:
      dockerfile: Dockerfile.dev
      context: ./api # it will find Dockerfile.dev into this context
    volumes:
      - usr/app/node_modules
      - ./api :usr/app # *** make sure to specify each volume to related folder
    environment: # specify environment variables
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - PGUSER=docker
      - PGHOST=postgres
      - PGDATABASE=multi_docker
      - PGPASSWORD=postgres_password
      - PGPORT=5432
  client:
    build:
      dockerfile: Dockerfile.dev
      context: ./client
    volumes:
      - usr/app/node_modules
      - ./client:usr/app
  worker:
    build:
      dockerfile: Dockerfile.dev
      context: ./worker
    volumes:
      - usr/app/node_modules
      - ./worker:usr/worker
```

### Postgres create init database

./postgres/init/01-filladb.sh

```shell
#!/bin/bash

# Immediately exits if any error occurs during the script
# execution. If not set, an error could occur and the
# script would continue its execution.
set -o errexit


# Creating an array that defines the environment variables
# that must be set. This can be consumed later via arrray
# variable expansion ${REQUIRED_ENV_VARS[@]}.
readonly REQUIRED_ENV_VARS=(
  "FILLA_DB_USER"
  "FILLA_DB_PASSWORD"
  "FILLA_DB_DATABASE"
  "POSTGRES_USER")


# Main execution:
# - verifies if all environment variables are set
# - runs the SQL code to create user and database
main() {
  check_env_vars_set
  init_user_and_db
}


# Checks if all of the required environment
# variables are set. If one of them isn't,
# echoes a text explaining which one isn't
# and the name of the ones that need to be
check_env_vars_set() {
  for required_env_var in ${REQUIRED_ENV_VARS[@]}; do
    if [[ -z "${!required_env_var}" ]]; then
      echo "Error:
    Environment variable '$required_env_var' not set.
    Make sure you have the following environment variables set:
      ${REQUIRED_ENV_VARS[@]}
Aborting."
      exit 1
    fi
  done
}


# Performs the initialization in the already-started PostgreSQL
# using the preconfigured POSTGRE_USER user.
init_user_and_db() {
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
     CREATE USER $FILLA_DB_USER WITH PASSWORD '$FILLA_DB_PASSWORD';
     CREATE DATABASE $FILLA_DB_DATABASE;
     GRANT ALL PRIVILEGES ON DATABASE $FILLA_DB_DATABASE TO $FILLA_DB_USER;
EOSQL
}

# Executes the main routine with environment variables
# passed through the command line. We don't use them in
# this script but now you know 🤓
main "$@"
```

./postgres/Dockerfile.dev

```Dockerfile
FROM postgres:alpine

ADD ./init /docker-entrypoint-initdb.d/
```

### Nginx path routing

#### default.conf

In order to setup nginx in the application to route the request off the appropriate backend we're gonna create a file called `default.conf`, this is a very special file to we're gonna added to our nginx image this file is gonna add a little bit of configuration to implement this set of routing routes:

- tell nginx that is an 'upstream' server at client:3000 and server:5000
- listen on port 80
- if someone comes to '/' send them to client upstream
- if someone comes to '/api' send them to server upstream

./nginx/default.conf

```conf
upstream client {
    # notice ;
    server client:3000;
}

upstream api{
    server api:5000;
}

server {
    listen 80;

    location / {
        proxy_pass http://client;
    }

    # react dev server request not handled WebSocket connection to ws Error
    location /sockjs-node {
        proxy_pass http://client;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
    }

    location /api {
        # rewrite will remove /api/ from request
        rewrite /api/(.*) /$1 break;
        proxy_pass http://api;
    }
}
```

#### Build a custom nginx image from

./nginx/Dockerfile.dev

```dockerfile
FROM nginx

# override the default.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf
```

### A continuous integration and deployment workflow for multiple images

- push code to git repository (in this case github)
- travis automatically pulls the codes
- travis builds a test image, test code
- travis builds a production image
- travis pushes built production image to docker hub
- travis push project to AWS EB
- AWS EB pulls images from docker hun, deploys

### Nginx on client

./client/nginx/default.conf

```conf
server {
    listen 3000;

    location / {
        root /user/share/nginx/html;
        index index.html index.htm;
        try_file $url $url/ /index.html; # *** make nginx works correctly with react-router
    }
}
```

./client/Dockerfile

```Dockerfile
FROM node:alpine as builder
WORKDIR /usr/app
COPY ./package.json .
RUN npm i
COPY . .
RUN npm run build

FROM nginx
EXPOSE 3000
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/app/build /usr/share/nginx/html
```

### Pushing image to docker hub

- login to docker

  > docker login

- push an image to docker hub

  > docker push IMAGE_ID/TAG

```yml
sudo: required
services:
  - docker
before_install:
  - docker build -t tajpouria/react-app -f ./client/Dockerfile.dev ./client # *** make sure to specify client directly as build context
script:
  - docker run tajpouria/react-app npm run test -- --coverage

after_success:
  - docker build -t tajpouria/multi-nginx ./nginx
  - docker build -t tajpouria/multi-postgres ./postgres
  - docker build -t tajpouria/multi-worker ./worker
  - docker build -t tajpouria/multi-server ./server
  - docker build -t tajpouria/multi-client ./client
  # login to docker-cli (using travis environment variables)
  # retrieve the docker password from environment variable and essentially emit that as input to the next command stdin channel
  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin
  # take those images and push them to docker hub
  - docker push tajpouria/multi-nginx
  - docker push tajpouria/multi-postgres
  - docker push tajpouria/multi-worker
  - docker push tajpouria/multi-server
  - docker push tajpouria/multi-client
```

# Kubernetes

## Why use kubernetes

If we were use kubernetes we can have additional machines running containers and we could had a lot of control over whats these additional machines were doing or what container they were running

### Kubernetes cluster

A **cluster** in world of kubernetes is an assembly of **master** and one or more **nodes**

- a node is a virtual machine or a physical computer that use to run some number of different containers
- in world of kubernetes are these nodes that have been created is manged by something named master, master contains a sets of program on it that control what each of these nodes is running at any given time

#### Kubernetes is a system for running many different containers over multiple different machines and used when you need to run many different containers with different images

### Kubernetes in development and production

For running kubernetes in development environment we using a program called **minikube**

- minikube is a command line tool and it's purpose is to setup tiny cluster on your local machine

when we start using kubernetes on production environment we very frequently use what are called **manage solutions**

- managed solutions are referenced to outside cloud provides such as Amazon Elastic Container Service for Kubernetes (EKS), Google Cloud Kubernetes Engine (GKS) and etc, that will setup entire kubernetes cluster for you

- in order to interact with this cluster we're going to use a program name **kubectl**

## Installing

These instructions were tested on a laptop with the desktop version of Linux Mint 19 Cinnamon installed. Current Ubuntu desktop version's setup should be the same. Your experience may vary if using an RHEL / Arch / Other distribution or non desktop distribution like Ubuntu server, or lightweight distributions which may omit many expected tools.

- Install VirtualBox:

Find your Linux distribution and download the .deb package, using a graphical installer here should be sufficient. If you use a package manager like apt to install from your terminal, you will likely get a fairly out of date version.

https://www.virtualbox.org/wiki/Linux_Downloads

After installing, check your installation to make sure it worked:

> VBoxManage —version

**For some reason Virtual box not worker for me and I used KVM instead:**

- Install KVM:

https://help.ubuntu.com/community/KVM/Installation :

> sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

https://askubuntu.com/questions/1050621/kvm-is-required-to-run-this-avd :

> sudo adduser \$USER kvm

https://minikube.sigs.k8s.io/docs/reference/drivers/kvm2/ :

> virt-host-validate

**Make sure no test failed**

> minikube start --vm-driver=kvm2

As an alternative you can use (or maybe you have to use) KVM instead of VirtualBox. Here are some great instructions that can be found in this post (Thanks to Nick L. for sharing):

https://computingforgeeks.com/install-kvm-centos-rhel-ubuntu-debian-sles-arch/

- Install Kubectl

In your terminal run the following:

> curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

> sudo mv ./kubectl /usr/local/bin/kubectl

Check your Installation:

> kubectl version

See also official docs:
https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux

- Install Minikube

In your terminal run the following:

> curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube

> sudo install minikube /usr/local/bin

Check your installation:

minikube version

- Start Minikube:

https://github.com/kubernetes/minikube/issues/2412 :

> minikube delete

> minikube start

See also official docs:

https://kubernetes.io/docs/tasks/tools/install-minikube/

- Gets the status of a local kubernetes cluster:

> minikube status

- display cluster info

> kubectl cluster-info

- VM ip

> minikube ip

### Mapping existing knowledge

|                         docker-compose                         |                    kubernetes                    | get a simple container running on our local kubernetes cluster running |
| :------------------------------------------------------------: | :----------------------------------------------: | :--------------------------------------------------------------------: |
| Each entry can optionally get docker-compose to build an image | Kubernetes expect all images to already be built |              Make sure our images is hosted on docker hub              |
|       Each entry represent a container we want to create       |  One config file per _object_ we want ot create  |              Make one config file to create the container              |
|     Each entry defines the networking requirements (ports)     |    We have to manually set up all networking     |               Make one config file to set up networking                |

### Adding configuration

#### terminology

**Config file describe the containers(or objects in k8s) we want**

the **object** in k8s world is a thing!! that will create in our cluster to make it behave the way we expect

- Pod: After we run `minikube start` it will create a virtual machine on computer we refer to that machine as a **node** we'll use this node to run different objects, one of this most basic object that we gonna create is refer as a **Pod**, a pod essentially is a grouping of very **closely**Jjk related container(s) with a very common purpose

- Service : we `Service` object type we we're gonna set up networking in a k8s cluster

- NodePort: is a **sub object type of Service object type** every time a request coming to **kubeProxy**(the single window to communicate to world outside of the node) then it will reach the nodePort and nodePort will link it to a container inside a Pod _nodePort is only uses for development purposes_

./simplek8s/client-pod.yml

```yml
apiVersion: v1 # Each API version defines a different set of object we can use
kind: Pod # Specify the object type we want to create, object serve different purpose for e.g. Pod: running a container, Service: networking
metadata:
  name: client-pod # the name of pod that get created
  labels:
    component: web # label that Pod to be able to select that from Service
spec:
  containers:
    - name: client
    image: tajpouria/multi-client
      ports:
      - containerPort: 3000 # on this container we want to expose port 3000 to the outside world
```

./simplek8s/client-node-port.yml

```yml
apiVersion: v1
kind: Service
metadata:
  name: client-node-port
spec:
  type: NodePort # exposes a container to the outside world(only good for development purposes)
  ports:
    - port: 3000 # the port that other Pod in our cluster can access to this Pod targetPort: 3000 # the port inside this Pod that we going open up traffic to nodePort: 31515 # the port we're going to use outside the node (in browser) in order to access to access the Pod ***(default: random number between 30000 and 32767)
       selector:
    component: web # select web pod by it's label
```

- Feed the config file to kubctl

> kubectl apply -f \<path to the file\>

- Retrieve information about a running object

> kubectl get \<object name\>

e.g. print the status of all running pods

> kubectl get pods

e.g. print the status of all services

> kubectl get services

- Show description of a specific resource or group of resource

> kubectl describe \<resource\J>

e.g a pod description

> kubectl describe client-pod

#### After applying Pod and nodePort configuration the node is available on NODE_IP:nodePort:

NODE_IP:

> minikube ip

nodePort: 31515

### the entire deployment workflow

- When we run `kubectl apply -f <filename>` the file is taken and pass into master
- On the master kube-apiServer will read configuration file and interpret it in some fashion
- kube-apiServer will update the cluster status based upon of configuration file and node(s) status
- kube-apiServer will tell node(s) that which container and how much copy of it should run
- each node have a copy of docker into it and it will use it to reach into docker hub to create container(s) of it
- kube-apiServer will update the status

## Sundry

### Node process exit status codes

- 0: we exited and everything is OK
- 1, 2, 3, etc: we exited because something went wrong

### Redis

#### pub/sub

```typescript
const client = redis.createClient({
  host,
  key,
  retry_strategy: () => 1000 // if ever loses the connection it's automatically try to reconnect every one second
});

const sub = client.duplicate(); // Duplicate all current options and return a new redisClient instance, to send regular command to redis while in subscriber mode, just open another connection with a new client.

sub.on("message", (channel, message) => {
  redisClient.hset("values", message, "hello"); // sets field in the hash stored at key to value e.g redis-cli>HSET my hash field1 "hello" redis-cli>HGET hash field1
});
sub.subscribe("insert");

const publisher = client.duplicate();
publisher.publish("insert", index);
```

#### hgetall

Get the all values inside a hash

```typescript
redis.hgetall("values", (err, values) => values);
```
