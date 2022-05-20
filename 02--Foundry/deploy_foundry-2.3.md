## <font color='red'>Deploy Hitachi Vantara Foundry Platform 2.3</font>

* Download the [Hitachi Vantara Foundry Platform 2.3](https://repo.wal.eng.hitachivantara.com/ui/native/foundry-generic-release/2.3.0) images and Charts.  


* Deploy OpenEBS storageclass
* Local Docker Registry
* Install Cluster Services




---


<em>Deploy OpenEBS Storage Class</em>

OpenEBS is a cloud native storage project originally created by MayaData that build on a Kubernetes cluster and allows Stateful applications to access Dynamic Local PVs and/or replicated PVs. OpenEBS runs on any Kubernetes platform and uses any Cloud storage solution including AWS s3, GKE and AKS.  
Its is not recommended for production environments.

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
Note: Only have storageclass set as default.
``patch 'local-path' storageclass:``
```
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```
``verify class set as default:``
```
kubectl get sc | grep default
```
Note: the openebs-hostpath is set as default.

---

<em>Docker Registry</em>

An OCI-compatible container image registry with an SSL certificate is required. Authentication credentials are also recommended.
When deploying both cluster services and the control plane, the fully qualified domain name of this registry must be specified, either using the -r argument or the installer config file. The value you specify needs to include both the host and port for your registry. For example:

``-r myregistry.example.com:5000``

``login into the Registry:``
```
docker login iiot-core.skytap.example:5000
Username: admin
Password: password
```

---

<em>Install Cluster Services</em>

Hitachi Vantara Foundry Platform Control plane expects that the Kubernetes cluster is running with, Istio, cert-manager and has a default StorageClass defined. 

Foundry install directory has to be at least two directories deep in file system.

``create a Foundry-2.3 & Logs directory:``
```
cd /data
sudo mkdir Logs
sudo mkdir Foundry-2.3
```

``untar Foundry-2.3 directory:``
```
cd /data
tar -C /data/Foundry-2.3 -xzvf  /data/Packages/Foundry-Control-Plane-2.3.0.tgz
```

tar -C /data/Foundry-2.3 -zxf &lt;/data/Packages/Foundry-Control-Plane-2.3.0.tgz&gt;


./install-cluster-services.sh -r $(hostname -f):5000 -I

/apply-crds.sh --insecure -e -r $(hostname):5000

./install-control-plane.sh -r $(hostname -f):5000 -I


