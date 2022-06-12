#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get install -y python3-pip vim git curl software-properties-common \
    && echo 'Installed base packages' | tee -a /opt/setup.log

apt-add-repository ppa:ansible/ansible -y && apt-get update && apt-get install -y ansible \
    && echo 'Installed ansible' | tee -a /opt/setup.log

ANSIBLE_LOG_PATH="/opt/ansible-setup.log" ansible-pull -U https://github.com/GraywellDesign/ansible setup.yml \
    && ANSIBLE_LOG_PATH="/opt/ansible-setup.log" ansible-pull -U https://github.com/GraywellDesign/ansible playbooks/servers/server.yml \
    && echo 'Ran ansible playbooks' | tee -a /opt/setup.log
