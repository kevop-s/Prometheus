#!/bin/bash
############################################
#                                          #
#                Grafana                   #
#                                          #
############################################

GRAFANA_CONTAINER="grafana"
GRAFANA_PASSWORD="password"
GRAFANA_PORT="3000"

firewall-cmd --permanent --add-port=$GRAFANA_PORT/tcp
firewall-cmd --reload

mkdir -p /var/containers/$GRAFANA_CONTAINER/{var/lib/grafana,var/log/grafana}
chown 472:0 -R /var/containers/$GRAFANA_CONTAINER

docker run -itd --name=$GRAFANA_CONTAINER \
    -p $GRAFANA_PORT:3000 \
    -v /etc/localtime:/etc/localtime:ro \
    -v /usr/share/zoneinfo:/usr/share/zoneinfo:ro \
    -v /var/containers/$GRAFANA_CONTAINER/var/lib/grafana:/var/lib/grafana:z \
    -v /var/containers/$GRAFANA_CONTAINER/var/log/grafana:/var/log/grafana:z \
    -e "TZ=America/Mexico_City" \
    -e "GF_SECURITY_ADMIN_PASSWORD=$GRAFANA_PASSWORD" \
    grafana/grafana:7.0.0