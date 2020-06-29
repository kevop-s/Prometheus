#!/bin/bash
############################################
#                                          #
#                Prometheus                #
#                                          #
############################################

PROMETHEUS_CONTAINER="prometheus"
PROMETHEUS_PORT="9090"
PROMETEHUS_ALIAS_MONITORING="kevops-monitoring"
PROMETHEUS_IP_LOCAL_SERVER="10.128.0.9"
PROMETHEUS_IP_LOCAL_NODE_EXPORTER="10.128.0.9"
PROMETHEUS_IP_LOCAL_CADVISOR="10.128.0.9"
PROMETHEUS_IP_EXTERNAL_NODE_EXPORTER="10.142.0.2"
PROMETHEUS_IP_EXTERNAL_CADVISOR="10.142.0.2"


firewall-cmd --permanent --add-port=$PROMETHEUS_PORT/tcp
firewall-cmd --reload

mkdir -p /var/containers/$PROMETHEUS_CONTAINER/etc/prometheus/

cat<<-EOF > /var/containers/$PROMETHEUS_CONTAINER/etc/prometheus/prometheus.yml
global:
    scrape_interval: 3s
    external_labels:
        monitor: '$PROMETEHUS_ALIAS_MONITORING'
scrape_configs:
    - job_name: 'prometheus'
      static_configs:
        - targets: ['$PROMETHEUS_IP_SERVER:$PROMETHEUS_PORT']
    - job_name: 'monitoring-local'
      static_configs:
          - targets: ['$PROMETHEUS_IP_LOCAL_NODE_EXPORTER:9100','$PROMETHEUS_IP_LOCAL_CADVISOR:8080']
    - job_name: 'monitoring-external'
      static_configs:
          - targets: ['$PROMETHEUS_IP_EXTERNAL_NODE_EXPORTER:9100','$PROMETHEUS_IP_EXTERNAL_CADVISOR:8080']
EOF

docker run -itd --name $PROMETHEUS_CONTAINER \
    -p $PROMETHEUS_PORT:9090 \
    -v /var/containers/$PROMETHEUS_CONTAINER/etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:z \
    -v /etc/localtime:/etc/localtime:ro \
    -v /usr/share/zoneinfo:/usr/share/zoneinfo:ro \
    -e "TZ=America/Mexico_City" \
    prom/prometheus