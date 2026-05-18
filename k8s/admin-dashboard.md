To install an admin GUI on a K3s cluster, a popular choice is Kubernetes Dashboard, which provides a web-based Kubernetes cluster management interface.
Here’s a step-by-step guide to install and access Kubernetes Dashboard on K3s:

On my WSL environment see `~/k8s/dashboard/` directory.

---
### Step 1: Deploy the Kubernetes Dashboard
Run the following command to deploy the official Kubernetes Dashboard manifest:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```
---
### Step 2: Create a Service Account and ClusterRoleBinding for Admin Access
Create a YAML file named dashboard-adminuser.yaml with the following content:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

Apply it:
```bash
kubectl apply -f dashboard-adminuser.yaml
```
---
### Step 3: Get the Bearer Token for Login
Run:
```bash
kubectl -n kubernetes-dashboard create token admin-user
```
This command will output a JWT token. Save it; you will use it to log into the dashboard.
---
### Step 4: Access the Dashboard
Since the Kubernetes Dashboard service is of type ClusterIP, you can use kubectl proxy to securely access it:
```bash
kubectl proxy
```
Then open your browser and go to:
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
Use the token from Step 3 for authentication.
---
### Optional: Expose Dashboard via LoadBalancer or NodePort (Not recommended for production without proper security)
If you want to expose the Dashboard externally, you can change its service type:
```bash
kubectl -n kubernetes-dashboard edit service kubernetes-dashboard
```
Modify type: ClusterIP to type: NodePort or LoadBalancer, then save.
---
### Summary
- K3s does not include a built-in admin GUI by default.
- You can install the Kubernetes Dashboard with the official manifests.
- Create an admin service account for authentication.
- Access the dashboard via kubectl proxy or by exposing it externally (less secure).
If you want a more feature-rich or user-friendly UI, you can also explore tools like Lens (a desktop Kubernetes IDE) or Rancher (which can manage multiple Kubernetes clusters including K3s).