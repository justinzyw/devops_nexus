#!/bin/bash

# Fetch the variables
. parm.txt

# function to get the current time formatted
currentTime()
{
  date +"%Y-%m-%d %H:%M:%S";
}

sudo docker service scale devops-nexu=0

echo ---$(currentTime)---populate the volumes---
#to zip, use: sudo tar zcvf devops_nexus_volume.tar.gz /var/nfs/volumes/devops_nexus*
sudo tar zxvf devops_nexus_volume.tar.gz -C /


echo ---$(currentTime)---create nexus service---
sudo docker service create -d \
--publish $NEXUS_ARTIFACT_PORT:8081 \
--publish $NEXUS_IMAGE_PORT:5000 \
--name devops-nexus \
--mount type=volume,source=devops_nexus_volume,destination=/nexus-data,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_nexus_volume \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$NEXUS_IMAGE

sudo docker service scale devops-nexu=1
