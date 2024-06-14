#!/bin/bash

# Determine toolpath if not set already
relativepath="./" # Define relative path to go from this script to the root level of the tool
if [[ ! -v toolpath ]]; then scriptpath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ); toolpath=$(realpath --canonicalize-missing ${scriptpath}/${relativepath}); fi

# Rename Folders if they exists Already
if [[ -d "/etc/snid" ]]
then
   mv /etc/snid /etc/networking-snid
fi

if [[ -d "/etc/containers-networking" ]]
then
   mv /etc/containers-networking /etc/networking-containers
fi

# Remove Previous Scripts that have been converted to Symlink
if [[ -f "/etc/snid/functions.sh" ]]
then
   rm -f "/etc/snid/functions.sh"
fi

if [[ -f "/etc/networking-containers/functions.sh" ]]
then
   rm -f "/etc/networking-containers/functions.sh"
fi

# Create Directory Structure for general
mkdir -p /etc/networking-general

# Create Directory Structure for snid
mkdir -p /etc/networking-snid
mkdir -p /etc/networking-snid/routes.external.d
mkdir -p /etc/networking-snid/routes.local.d
mkdir -p /etc/networking-snid/servers.local.d

# Create Directory Structor for containers
mkdir -p /etc/networking-containers
mkdir -p /etc/networking-containers/addresses.local.d

# Copy Scripts
cp ${toolpath}/etc/networking-snid/*.sh /etc/networking-snid/
cp ${toolpath}/etc/networking-containers/*.sh /etc/networking-containers/
cp ${toolpath}/etc/networking-general/*.sh /etc/networking-general/

# Copy Systemd Services
cp ${toolpath}/etc/systemd/system/*.service /etc/systemd/system/

# Reload Systemd Daemon
systemctl daemon-reload
