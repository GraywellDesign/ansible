#!/usr/bin/env bash

command="$@"

doctl compute droplet list --format='PublicIPv4' | grep -v 'Public IPv4' > servers.txt

for server in $(cat servers.txt)
do
	shortname=$(echo ${server} | cut -d'.' -f1)
	ssh -tt ${server} bash -c "'
	${command}
	'"
done
