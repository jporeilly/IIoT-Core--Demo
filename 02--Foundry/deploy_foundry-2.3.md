## <font color='red'>Deploy Hitachi Vantara Foundry Platform 2.3</font>

To download the Hitachi Vantara Foundry Platform 2.3 images and Charts, you will need to contact your Account Manager.  
* The artifacts are not publicly available. 
* To save time, the artifacts have already been downloaded.

* Deploy OpenEBS storageclass







<em>Deploy OpenEBS Storage Class</em>



``check default storage class:``
```
kubebctl get sc
```
Note: the default is set to 'local-path'.

``add helm openEBS chart:``
```
helm repo add openebs https://openebs.github.io/charts
helm repo update
```
``create openebs namespace:``
```
kubectl create ns openebs
```
``deploy openEBS:``
```
helm install --namespace openebs openebs openebs/openebs
```
``check the status:``
```
kubectl get pods -n openebs
```
``patch storageclass to set as default:``
```
kubectl patch storageclass openebs-hostpath -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
``verify class set as default:``
```
kubectl get sc | grep default
``

