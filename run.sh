#!/bin/sh

set -e
set -x

## Commands to run on container start
# Comment out any line with localhost to not confuse lesser clients
cp /etc/hosts /etc/hosts.bak && \
sed '/localhost/ s/^#*/#/' /etc/hosts.bak > /etc/hosts && \
rm /etc/hosts.bak
# Allow tests to connect to containers as they where on localhost
echo "$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.Gateway}}{{end}}' "$(hostname)") localhost" >> /etc/hosts

# CloudBees standard "wait for exec" command
/bin/cat
