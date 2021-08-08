# AKS

Check azure official doc: [Create a Kubernetes cluster with Azure Kubernetes Service using Terraform](https://docs.microsoft.com/zh-tw/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks?WT.mc_id=AZ-MVP-5003985)

# Access AKS

prerequisite
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/)

```
KUBECONFIG_OUTPUT_PATH="/Users/che-chia/.kube/azure-aks"

kubectl --kubeconfig ${KUBECONFIG_OUTPUT_PATH} cluster-info

kubectl --kubeconfig ${KUBECONFIG_OUTPUT_PATH} get node

NAME                              STATUS   ROLES   AGE    VERSION
aks-default-44401806-vmss000000   Ready    agent   9m4s   v1.20.7
```
