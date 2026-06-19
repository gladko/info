## K3s on disk
K3s binary: /usr/local/bin/k3s
K3s data directory: /var/lib/rancher/k3s/
K3s configurations:
 - /etc/systemd/system/k3s.service
 - /etc/systemd/system/k3s-agent.service
 - /etc/rancher/k3s/config.yaml   (if you created one)
 - /etc/rancher/k3s/k3s.yaml
 - ~/.kube/config/
Logs: /var/log/syslog


We can check that our cluster is running:
```bash
$ kubectl get nodes
NAME              STATUS   ROLES                  AGE    VERSION
<cluster-name>   Ready    control-plane,master   4d3h   v1.25.6+k3s1
```

Notably, we can see that the control plane will run together with the master node.
Let’s now have a look at which containers (pods) get created:
```bash
$ kubectl get pods --all-namespaces
NAMESPACE              NAME                                         READY   STATUS             RESTARTS         AGE
kube-system            helm-install-traefik-crd-6v28l               0/1     Completed          0                4d2h
kube-system            helm-install-traefik-vvfh2                   0/1     Completed          2                4d2h
kube-system            svclb-traefik-cfa7b330-fkmms                 2/2     Running            10 (8h ago)      4d2h
kube-system            traefik-66c46d954f-2lvzr                     1/1     Running            5 (8h ago)       4d2h
kube-system            coredns-597584b69b-sq7mk                     1/1     Running            5 (8h ago)       4d2h
kube-system            local-path-provisioner-79f67d76f8-2dkkt      1/1     Running            8 (8h ago)       4d2h
```


## k8s init and system info
```bash
sudo systemctl start k3s
sudo systemctl start k3s-agent

sudo systemctl status k3s
journalctl -u k3s
kubectl cluster-info
kubectl get addons -A
kubectl describe addon -n kube-system <addon-name>
```

## check status
```bash
kubectl logs <POD-NAME>
kubectl exec -it <POD-NAME> -- bin/bash

kubectl get all
kubectl get nodes

kubectl get pods --all-namespaces

kubectl get pod -o wide
kubectl get pod -o yaml

kubectl get pod --watch

kubectl describe pod <POD_NAME>
kubectl describe service <SERVICE-NAME>
```

## test call of K8s API server
```bash
# create token 
kubectl -n kubernetes-dashboard create token admin-user --duration=24h

# make call using token
curl -k -H "Authorization: Bearer $TOKEN" https://127.0.0.1:6443/api
```

## deploy
```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

## delete
```bash
kubectl delete -n default deployment vk-cloud-hello
kubectl delete -n default service k8s-hello-service

kubectl delete all --all -n default
```

## Check the NodePort assigned:
```bash
kubectl get svc

NAME                TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
python-app-service   NodePort   10.43.255.100   <none>        80:3xxxx/TCP     1m
```
The 3xxxx is the NodePort on your local machine (WSL) `curl http://localhost:<NodePort>`


## прокинуть порт из wsl
```powershel
  netsh interface portproxy add v4tov4 listenport=6443 listenaddress=0.0.0.0 connectport=6443 connectaddress=172.17.244.18
```


## Cluster Example

1. Let’s make a simple cluster example in which we will install an Nginx image.
First, let’s create a deployment from an Nginx image with three replicas available on port 80:
`kubectl create deployment nginx --image=nginx --port=80 --replicas=3`

Next, let’s check out our pods:
```bash
$ kubectl get pods
NAME                    READY   STATUS    RESTARTS   AGE
nginx-ff6774dc6-ntxv6   1/1     Running   0          17s
nginx-ff6774dc6-qs4r6   1/1     Running   0          17s
nginx-ff6774dc6-nbxmx   1/1     Running   0          17s
```
We should see three running containers.

2. Pods are not permanent resources and get created and destroyed constantly. Therefore, we need a Service to map the pods’ IPs to the outer world dynamically.
Services can be of different types. We’ll choose a ClusterIp:
`kubectl create service clusterip nginx --tcp=80:80`

Let’s have a look at our Service definition:
```bash
$ kubectl describe service nginx
Name:              nginx
Namespace:         default
Labels:            app=nginx
Annotations:       <none>
Selector:          app=nginx
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                10.43.238.194
IPs:               10.43.238.194
Port:              80-80  80/TCP
TargetPort:        80/TCP
Endpoints:         10.42.0.10:80,10.42.0.11:80,10.42.0.9:80
```

We can see the Endpoints corresponding to the pods (or containers) addresses where we can reach our applications.

3. Services don’t have direct access. An Ingress Controller is usually in front of them for caching, load balancing, and security reasons, such as filtering out malicious requests.
Finally, let’s define a Traefik controller in a YAML file. This will route the traffic from the incoming request to the service:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  annotations:
    ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx
            port:
              number: 80
```
We can create the ingress by applying this resource to the cluster:
`kubectl apply -f <nginx-ingress-file>.yaml`

Let’s describe our ingress controller:
```bash
$ kubectl describe ingress nginx
Name:             nginx
Labels:           <none>
Namespace:        default
Address:          192.168.1.103
Ingress Class:    traefik
Default backend:  <default>
Rules:
  Host        Path  Backends
  ----        ----  --------
  *           
              /   nginx:80 (10.42.0.10:80,10.42.0.11:80,10.42.0.9:80)
Annotations:  ingress.kubernetes.io/ssl-redirect: false
```
Our Backends will run the Nginx application on the available Services’ ports.
4. We can now access the Nginx home page with a GET request to the 192.168.1.103 address from our host or a browser.
We might want to add a Load Balancer to the ingress controller. K3s uses ServiceLB as default.

5. clean up
```bash
kubectl delete -n default deployment nginx
kubectl delete -n default service nginx
kubectl delete -n default ingress nginx
```

## start local containers registry
docker run -d -p 5000:5000 --restart always --name registry registry:3

## generate deploymen.yaml for specified APP
```bash
$ mkdir k8s
$ kubectl create deployment <APP-NAME> --image localhost:5000/apps/demo -o yaml --dry-run=client > k8s/deployment.yaml
$ kubectl create service clusterip <APP-NAME> --tcp 80:8080 -o yaml --dry-run=client > k8s/service.yaml
```