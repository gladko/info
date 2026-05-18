## Terms
- Kubernetes
- containerd is container runtime
- CRI-O
- docker
- etcd
- Kubernetes API is exposed by Control Plane
- Minikube / kind / k3s is a lightweight Kubernetes implementation for local machine
- kubectl is Kubernetes command-line tool
- kubeadm ia a tool to create and manage Kubernetes clusters

## Resources
A Kubernetes cluster consists of two types of resources:
- The `Master node` or `Control Plane` coordinates the cluster
- `Nodes` are the workers that run applications

Master node contains:
- API server:  cluster gateway
- Scheduler: starts/stops nodes and pods. Distributes pods over nodes
- Controller manager: detects cluster state changes. Reschedules pods if any dies
- etcd: cluster state storage

 Worker machine (`node`) in k8s cluster has:
 - container runtime  (containerd or CRI-O)
 - `kubelet` is an agent for managing the node and communicating with the Kubernetes control plane.
 - kube proxy

## K8s components
- Node: worker node. Physical or virtual machine
- Pod: smalest unit of k8s. Abstraction over container
- Service: permanent IP address. Kind of facade for pods
- Ingress: proxy for external incoming requests
- ConfigMap: external config of application
- Secrets: config-map for secret data
- Volumes: permanent storage
- StatefulSet
- Deployment: blueprint for my-app pods

## Commands
```bash
sudo systemctl stop k3s
sudo systemctl stop k3s-agent
sudo systemctl status k3s
```

## check status
 kubectl cluster-info
 curl -k https://127.0.0.1:6443


## deploy
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

## Check the NodePort assigned:
```bash
kubectl get svc python-app-service

NAME                TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
python-app-service   NodePort   10.43.255.100   <none>        80:3xxxx/TCP     1m
```
The 3xxxx is the NodePort on your local machine.

Open in your browser or curl:
http://localhost:<NodePort>
