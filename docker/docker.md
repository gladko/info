[guide](https://docs.docker.com/get-started)								
[my personal docker repository](https://cloud.docker.com/repository/docker/vladika/vk.test.repo/general)	
[Redis CLI in docker](https://markheath.net/post/exploring-redis-with-docker)
[Docker Visualization](https://github.com/dockersamples/docker-swarm-visualizer)

[running `perf` in docker & kubernetes](https://medium.com/@geekidea_81313/running-perf-in-docker-kubernetes-7eb878afcd42)

## run linux
```bash
docker run -d --name mylinux ubuntu:22.04 tail -f /dev/null
docker exec -it mylinux bash

docker run -d --name mylinux eclipse-temurin:21-jre tail -f /dev/null
docker run -d --name myrocky rockylinux:9 tail -f /dev/null
docker run -d --name mylinux alpine  tail -f /dev/null

docker exec -ti <container_name> bash

# If you want a “real” Linux environment with systemd:
docker run -d --privileged --name sysd ubuntu:22.04 /sbin/init
```

## Docker info
```bash
docker --version
docker version
docker info
```

## Docker images
```bash
docker images
docker image ls						## List Docker images
docker image ls -a                     			# List all images on this machine
docker images -q
docker image rm <image id>           			# Remove specified image from this machine
docker rmi {IMAGE_NAME}
docker image rm $(docker image ls -a -q)		# Remove all images from this machine
```


## Docker containers
```bash
docker container ls
docker container ls --all    # all
docker container ls -aq	     # quiet mode
```


//////////////////////////////////////////////////////////////////////
	BUILD & RUN
//////////////////////////////////////////////////////////////////////
```bash
docker build -t friendlyhello .					# Create image using this directory's Dockerfile
docker build --tag={IMAGE_NAME} .

# run
docker run -p 4000:80 friendlyhello 			# Run "friendlyhello" mapping port 4000 to 80
docker run -d -p 4000:80 friendlyhello			# Same thing, but in detached mode
docker run -d -p 4000:80 --name <container-name> <image-name>

# manage containers
docker ps	
docker container ls                  			# List all running containers
docker container stop <hash>       		    	# Gracefully stop the specified container
docker container kill <hash>      		   		# Force shutdown of the specified container
docker container rm <hash>       				# Remove specified container from this machine
docker container rm $(docker container ls -a -q)	# Remove all containers

# remove
docker rm <container-name>				# Removes container
docker rm -f <the-container-id>				# stop and remove a container in a single command
docker rm $(docker ps -a -q  --filter ancestor=hello-world)
docker stop <container-name>
docker stop $(docker ps -q --filter ancestor=friendlyhello )

docker kill $(docker ps -q) 		kill all running containers
docker rm $(docker ps -a -q)		delete all containers
docker rmi $(docker images -q)		delete all images

# exec
docker exec -it <container-name> bash
docker exec -it <container-name> sh

```


//////////////////////////////////////////////////////////////////////
	Docker repo
//////////////////////////////////////////////////////////////////////
```bash
docker login            				# Log in this CLI session using your Docker credentials
docker tag <image> username/repository:tag 		# Tag <image> for upload to registry
docker push username/repository:tag        	    	# Upload tagged image to registry
docker run username/repository:tag   			# Run image from a registry
```

*Make sure to change tagname with your desired image repository tag.*
docker tag local-image:tagname new-repo:tagname
docker push new-repo:tagname


//////////////////////////////////////////////////////////////////////
#	Local docker repo
//////////////////////////////////////////////////////////////////////
```bash
# start repo
docker run -d -p 5000:5000 --restart always --name registry registry:3

# Push image to local docker repo
docker tag <IMAGE_NAME>:latest localhost:5000/<IMAGE_NAME>:latest
docker push localhost:5000/<IMAGE_NAME>:latest

# observer pushed images
curl http://localhost:5000/v2/_catalog

# remove the image
# 1. Find the image digest
http://localhost:5000/v2/{APP-NAME}/tags/list


```