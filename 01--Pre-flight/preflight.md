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
cd /data/Workshop-DC/01--Pre-flight
sudo ./pre-flight_dc.sh
```

--- 

<em>Docker Registry</em>

The Docker Regsitry is installed as a container.

``deploy Registry container:``
```
cd /data/Docker-Registry
docker-compose up -d
```
Note: check that the container is up and running

Docker client always attempts to connect to registries by first using HTTPS. You must configure your Docker client so that it can connect to insecure registries. In your Docker client is not configured for insecure registries, you will see the following error when you attempt to pull or push images to the Registry:  

```Error response from daemon: Get https://myregistrydomain.com/v2/users/: dial tcp myregistrydomain.com:443 getsockopt: connection refused.```

Resolution: 
* Ensure the /etc/docker/daemon.json has the IP or FQDN. 
* Ensure all the containers have started. Check containers in Docker section of VSC.

```
{
"insecure-registries" : ["myregistrydomain.com:port", "0.0.0.0"]
}
```

* finally test that the Docker Regsitry is up and running

  > navigate to: http://localhost:8080

``login into the Registry:``
```
docker login localhost:5000
Username: admin
Password: admin   
```

---

<em>Install k3s - Rancher</em> 

K3s is an official CNCF sandbox project that delivers a lightweight yet powerful certified Kubernetes distribution designed for production workloads across resource-restrained, remote locations or on IoT devices.

``run the script:``
```
cd /data/Workshop-DC/01--Pre-flight
sudo ./install_k3s.sh
```
Note: k3s is installed with Traefik disabled. Not required for single node.

---

