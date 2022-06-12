#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get install -y python3-pip vim git curl \
  && echo 'Installed base packages' | tee -a /opt/setup.log

pip3 install ansible

ANSIBLE_LOG_PATH="/opt/ansible-setup.log" ansible-pull -U https://github.com/GraywellDesign/ansible setup.yml \
    && ANSIBLE_LOG_PATH="/opt/ansible-setup.log" ansible-pull -U https://github.com/GraywellDesign/ansible playbooks/servers/server.yml \
    && echo 'Ran ansible playbooks' | tee -a /opt/setup.log
