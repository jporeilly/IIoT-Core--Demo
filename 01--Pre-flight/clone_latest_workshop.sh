#!/bin/bash

# ===========================================================================
# check Workshop-IIoT-Core directory exists
# remove Workshop-IIoT-Core
# create Workshop-IIoT-Core directory
# clone remote git Pentaho--Containers repository to /data/Workshop-IIoT-Core
3
# dont forget to close and open VSC ..
# 21/05/2022
# ===========================================================================

remoteHost=github.com
remoteUser=jporeilly
localUser=k8s
remoteDir=IIoT-Core--Demo
remoteRepo=http://$remoteHost/$remoteUser/$remoteDir
localDirW=~/Workshop-IIoT-Core
localDirS=~/Scripts
localDirR=~/Docker-Registry

if [ -d "$localDirW" -a ! -h "$localDirW" ]
then
    echo -e "Directory $localDirW exists .." 
    echo -e "Deleting $localDirW .."
    rm -rf $localDirW
else
    echo -e "Error: Directory $localDirW does not exists .."
fi
    echo -e "Creating $localDirW directory .."
    mkdir $localDirW
    git clone $remoteRepo $localDirW
    chown -R $localUser $localDirW
    sleep 1s
    echo -e "Update of Workshop - IIoT-Core is completed .."

    echo -e "Copy pre-flight.sh .."
if [ -d "$localDirS" -a ! -h "$localDirS" ]
then
    echo -e "Directory $localDirS exists .." 
    echo -e "Deleting $localDirS .."
    rm -rf $localDirS
else
    echo -e "Error: Directory $localDirS does not exists .."
fi 
    echo -e "Creating $localDirS directory .."
    mkdir $localDirS   
    cp $localDirW/01--Pre-flight/pre-flight_iiot-core.sh $localDirS
    chown -R $localUser $localDirS
    chmod +x $localDirS/pre-flight_iiot-core.sh
    cp $localDirW/01--Pre-flight/deploy_k3s-1.21.12.sh $localDirS
    chown -R $localUser $localDirS
    chmod +x $localDirS/deploy_k3s-1.21.12.sh
    cp $localDirW/01--Pre-flight/docker-compose.yml $localDirR
    sleep 1s
    echo -e "Scripts copied .."



