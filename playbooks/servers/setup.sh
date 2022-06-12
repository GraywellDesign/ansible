#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# If Arch Linux
if grep -q 'Arch Linux' /etc/os-release
then
	pacman -Syu --noconfirm --overwrite '*' ansible git vim curl \
		&& echo 'Installed base packages' | tee -a /opt/setup.log
        ln -s /usr/bin/vim /usr/bin/vi
fi

# If Debian-based
if [[ -e /etc/debian_version ]]
then
	apt-get update && apt-get dist-upgrade -y
	apt-get install -y python3-pip vim git curl \
		&& echo 'Installed base packages' | tee -a /opt/setup.log

	pip3 install ansible
fi

ANSIBLE_LOG_PATH="/opt/ansible-setup.log" ansible-pull -U https://github.com/GraywellDesign/ansible setup.yml \
	&& ANSIBLE_LOG_PATH="/opt/ansible-setup.log" ansible-pull -U https://github.com/GraywellDesign/ansible playbooks/servers/server.yml \
	&& echo 'Ran ansible playbooks' | tee -a /opt/setup.log
