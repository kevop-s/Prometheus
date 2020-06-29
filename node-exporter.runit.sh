#!/bin/bash
############################################
#                                          #
#              Node Exporter               #
#                                          #
############################################

NODE_EXPORTER_CONTAINER="node-exporter"
NODE_EXPORTER_PORT="9100"

firewall-cmd --permanent --add-port=$NODE_EXPORTER_PORT/tcp
firewall-cmd --reload

docker run -itd --name $NODE_EXPORTER_CONTAINER \
    --cap-add=SYS_TIME \
    --net="host" \
    --pid="host" \
    -v "/:/node-exporter:ro" \
    quay.io/prometheus/node-exporter --path.rootfs=/node-exporter