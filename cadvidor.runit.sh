#!/bin/bash
############################################
#                                          #
#               Cadvisor                   #
#                                          #
############################################

CADVISOR_CONTAINER="cadvisor"
CADVISOR_PORT="8080"

firewall-cmd --permanent --add-port=$CADVISOR_PORT/tcp
firewall-cmd --reload

docker run -d --name $CADVISOR_CONTAINER --privileged=true \
    -p $CADVISOR_PORT:8080 \
    -v /:/rootfs:ro \
    -v /var/run:/var/run:rw \
    -v /sys:/sys:ro \
    -v /var/lib/docker/:/var/lib/docker:ro \
    -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
    -v /dev/mapper:/dev/mapper:ro \
    -v /etc/localtime:/etc/localtime:ro \
    -v /usr/share/zoneinfo:/usr/share/zoneinfo:ro \
    -e "TZ=America/Mexico_City" \
    gcr.io/google-containers/cadvisor