## <font color='red'>Installation of Data Catalog 7.0</font>

To download the Data Catalog images and Charts, you will need to contact your Account Manager.  
* The artifacts are not publicly available. 
* To save time, the artifacts have already been downloaded.

The local Docker Registry has frontend UI.

  > navigate to: http://localhost:8080

``login into the Registry:``
```
docker login localhost:5000
Username: admin
Password: admin   
```

``upload images:``
```
cd Downloads
./ldc-load-images.sh -i ldc-images-7.0.0-rc.7.tar.gz -r localhost:5000
```

``create a ldc namespace in k3s:``
```
kubectl create namespace ldc
kubectl get namespace
```

``install Data Catalog:``
```
helm install ldc ldc-7.0.0-rc.7.tgz --set global.registry=localhost:5000 -f values.yml -n ldc
```

``check all Pods:``
```
kubectl get all
```
Note: make a note of the