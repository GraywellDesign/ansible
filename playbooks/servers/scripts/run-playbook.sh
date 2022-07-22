#!/usr/bin/env bash

if [[ -z $1 ]]
then
	echo "Usage: $0 [192.168.1.1] [all]"
fi

if [[ $1 == 'all' ]]
then
	doctl compute droplet list --format='PublicIPv4' | grep -v 'Public IPv4' > servers.txt

	for server in $(cat servers.txt)
	do
		shortname=$(echo ${server} | cut -d'.' -f1)
		ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -tt ${server} bash -c "'
		dpkg -l | grep ansible && sudo apt-get remove -y ansible
		sudo apt-get update && sudo apt-get install -y python3-pip && sudo python3 -m pip install --upgrade pip && sudo python3 -m pip install ansible --upgrade ansible==4.10.0 
		sudo ANSIBLE_LOG_PATH="/var/log/ansible.log" ansible-pull -U https://github.com/GraywellDesign/ansible setup.yml
		sudo ANSIBLE_LOG_PATH="/var/log/ansible.log" ansible-pull -U https://github.com/GraywellDesign/ansible playbooks/servers/server.yml
		'"
	done
fi

if [[ -n $1 ]]
then
	server="$1"		
	ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -tt ${server} bash -c "'
	dpkg -l | grep ansible && sudo apt-get remove -y ansible
	sudo apt-get update && sudo apt-get install -y python3-pip && sudo python3 -m pip install --upgrade pip && sudo python3 -m pip install ansible --upgrade ansible==4.10.0 
	sudo ANSIBLE_LOG_PATH="/var/log/ansible.log" ansible-pull -U https://github.com/GraywellDesign/ansible setup.yml
	sudo ANSIBLE_LOG_PATH="/var/log/ansible.log" ansible-pull -U https://github.com/GraywellDesign/ansible playbooks/servers/server.yml
	'"

fi
