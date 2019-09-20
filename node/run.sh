#!/bin/sh

set -e
set -x

## Commands to run on container start
# Allow tests to connect to containers as they where on localhost
echo "$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.Gateway}}{{end}}' "$(hostname)") localhost" >> /etc/hosts

# CloudBees standard "wait for exec" command
/bin/cat
