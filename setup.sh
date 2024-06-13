#!/bin/bash

# Determine toolpath if not set already
relativepath="./" # Define relative path to go from this script to the root level of the tool
if [[ ! -v toolpath ]]; then scriptpath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ); toolpath=$(realpath --canonicalize-missing ${scriptpath}/${relativepath}); fi

# Create Directory Structures
mkdir -p /etc/snid
mkdir -p /etc/snid/routes.external.d
mkdir -p /etc/snid/routes.local.d
mkdir -p /etc/snid/servers.local.d

mkdir -p /etc/containers-networking
mkdir -p /etc/containers-networking/addresses.local.d

# Copy Scripts
cp ${toolpath}/etc/snid/*.sh /etc/snid/
cp ${toolpath}/etc/containers-networking/*.sh /etc/containers-networking/

# Copy Systemd Services
cp ${toolpath}/etc/systemd/system/*.service /etc/systemd/system/
