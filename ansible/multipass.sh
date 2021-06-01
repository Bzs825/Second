#!/usr/bin/env bash

INSTANCE_NAME=test
multipass.exe launch --name $INSTANCE_NAME -m 4G -d 20G -c 2 --cloud-init cloud-config.yaml
INSTANCE_IP=$(multipass.exe info $INSTANCE_NAME | grep 'IPv4' | awk '{print $2}')

INSTANCE_IP=${INSTANCE_IP//$'\r'/}
echo -e "[multipass]" >hosts
echo -e "$INSTANCE_IP    ansible_connection=ssh    ansible_user=ansible" >>hosts

ansible-playbook mk8s.yaml -i hosts

ansible-playbook deployment.yaml -i hosts

ansible-playbook helm.yaml -i hosts