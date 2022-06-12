#!/usr/bin/env bash

doctl compute droplet list --format='PublicIPv4' | grep -v 'Public IPv4' > servers.txt

for server in $(cat servers.txt)
do
	shortname=$(echo ${server} | cut -d'.' -f1)
	ssh -tt ${server} bash -c "'
	sudo ANSIBLE_LOG_PATH="/var/log/ansible.log" ansible-pull -U https://github.com/GraywellDesign/ansible playbooks/servers/server.yml
	'"
done
