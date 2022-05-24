## <font color='red'>IIoT 5.0 Preflight - Hardware & Utils</font>  

The following pre-requisites configure IIoT Core 5.0

Prerequisites for the iIIoT Core 5.0 server:
* Docker
* Docker Compose
* Docker Registry + UI 

* k3s - Rancher

<font color='teal'>This section is for reference only. These tasks have already been completed.</font>

---

<em>Install Docker / Docker Compose</em>

The following script prepares a RHEL 8.4 server for IIoT Core 5.0.  
Docker Registry is installed with a HTTP connection (insecure).

``run the script:``
```
cd Scripts
sudo ./pre-flight_iiot-core.sh
```

--- 

<em>Docker Registry</em>

By default, Docker client uses a secure connection over TLS to upload or download images to or from a private registry. You can use TLS certificates signed by CA or self-signed on Registry server.

``create certs directory:``
```
sudo mkdir -p /certs
```
``create certs:``
```
sudo openssl req -newkey rsa:4096 -nodes -sha256 -keyout /certs/registry.key -x509 -days 365 -out /certs/registry.crt -subj "/CN=dockerhost" -addext "subjectAltName=DNS:iiot-core.skytap.example"
```

``copy certs to Registry:``
```
sudo cp /certs/registry.* /data/Docker-Registry/certs
```

``copy certs to Docker:``
```
sudo mkdir -p /etc/docker/certs.d/iiot-core.skytap.example:5000
sudo cp /certs/registry.* /etc/docker/certs.d/iiot-core.skytap.example:5000
```

``copy certs to Node:``
```
sudo cp /certs/registry.* /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust
```

``restart docker:``
```
sudo systemctl restart docker
```

``add port to firewalld :``
```
firewall-cmd --permanent --add-port=5000/tcp
firewall-cmd --reload
```
Note: not required as firewall is disabled.

The Docker Regsitry is installed as a container.

``deploy Registry container:``
```
cd /data/Docker-Registry
docker-compose up -d
```
Note: check that the container is up and running -Visual Studio Code

Docker client always attempts to connect to registries by first using HTTPS. You must configure your Docker client so that it can connect to insecure registries. In your Docker client is not configured for insecure registries, you will see the following error when you attempt to pull or push images to the Registry:  

```Error response from daemon: Get https://myregistrydomain.com/v2/users/: dial tcp myregistrydomain.com:443 getsockopt: connection refused.```

Resolution: 
* Ensure the /etc/docker/daemon.json has the IP or FQDN. 
* Ensure all the containers have started. Check containers in Docker section of VSC.

```
cd /etc/docker
sudo nano daemon.json
```

``check the entry:``
```
{
"insecure-registries" : ["iiot-core.skytap.example:5000", "0.0.0.0"]
}
```

* finally test that the Docker Regsitry is up and running

  > navigate to: http://iiot-core.skytap.example:8080

``login into the Registry:``
```
docker login localhost:5000
Username: admin
Password: password  
```

``check certs:``
```
openssl s_client -showcerts -connect iiot-core.skytap.example:5000
```

---

<em>Install k3s - Rancher</em> 

K3s is an official CNCF sandbox project that delivers a lightweight yet powerful certified Kubernetes distribution designed for production workloads across resource-restrained, remote locations or on IoT devices.

``run the script:``
```
cd Scripts
./deploy_k3s-1.21.12.sh
```
Note: k3s is installed with Traefik. 

If you're having problems connecting to the node, ensure that the /etc/rancher/k3s/k3s.yaml has been copied over to the ~/.kube/config and is chown k8s. 


``uninstall Rancher:``
```
cd /usr/local/bin/
sudo ./k3s-uninstall.sh
```
---

On bootup, RKE2 will check to see if a registries.yaml file exists at /etc/rancher/r3s/ and instruct containerd to use any registries defined in the file. If you wish to use a private registry, then you will need to create this file as root on each node that will be using the registry.

``/etc/rancher/k3s/registries.yaml:``
```
cd /etc/rancher/k3s
sudo nano registries.yaml
```

``add the following:``
```
mirrors:
  docker.io:
    endpoint:
      - "https://iiot-core.skytap.example:5000"
configs:
  "iiot-core.skytap.example:5000":
    auth:
      username: admin # this is the registry username
      password: password # this is the registry password
    tls:
      cert_file: /cert/registry.crt # path to the cert file used in the registry
      key_file:  /cert/registry.key # path to the key file used in the registry
      ca_file:   # path to the ca file used in the registry
```

``check certs:``
```
openssl s_client -showcerts -connect iiot-core.skytap.example:5000
```