#!/bin/bash

# Determine toolpath if not set already
relativepath="./" # Define relative path to go from this script to the root level of the tool
if [[ ! -v toolpath ]]; then scriptpath=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ); toolpath=$(realpath --canonicalize-missing ${scriptpath}/${relativepath}); fi

# Load Configuration
if [[ -f "${toolpath}/config.sh" ]]
then
    source "${toolpath}/config.sh"
fi

# Create Directory Structure for general
mkdir -p /etc/networking-general
mkdir -p /etc/networking-general/routes.external.d
mkdir -p /etc/networking-general/routes.local.d

# Copy Scripts
cp ${toolpath}/etc/networking-general/*.sh /etc/networking-general/

# Copy Systemd Services
cp ${toolpath}/etc/systemd/system/general-*.service /etc/systemd/system/

# Chown
chown -R root:root /etc/networking-general/

# Ensure Executable Permission
chmod +x /etc/networking-general/*.sh

# Reload Systemd Daemon
systemctl daemon-reload
systemctl daemon-reexec

# Find matching Services
mapfile -t files < <( find "/etc/systemd/system/" -iname "general-*.service" | grep $(basename) )

for file in "${files[@]}"
do
    # Enable Systemd Services
    systemctl enable $(basename "${file}")

    # Restart Systemd Services
    systemctl restart $(basename "${file}")
done

if [[ "${SETUP_SNID_NETWORKING}" == "yes" ]]
then
    # Rename Folders if they exists Already
    if [[ -d "/etc/snid" ]]
    then
        mv /etc/snid /etc/networking-snid
    fi

    # Remove Previous Scripts that have been converted to Symlink
    if [[ -f "/etc/networking-snid/functions.sh" ]]
    then
        rm -f "/etc/networking-snid/functions.sh"
    fi

    # Create Directory Structure for snid
    mkdir -p /etc/networking-snid
    mkdir -p /etc/networking-snid/routes.external.d
    mkdir -p /etc/networking-snid/routes.local.d
    mkdir -p /etc/networking-snid/servers.local.d

    # Symlink to common functions.sh File
    cd /etc/networking-snid || exit
    ln -s ../networking-general/functions.sh functions.sh

    # Copy Scripts
    cp ${toolpath}/etc/networking-snid/*.sh /etc/networking-snid/

    # Copy Systemd Services
    cp ${toolpath}/etc/systemd/system/snid-*.service /etc/systemd/system/

    # Reload Systemd Daemon
    systemctl daemon-reload
    systemctl daemon-reexec

    # Find matching Services
    mapfile -t files < <( find "/etc/systemd/system/" -iname "snid-*.service" | grep $(basename) )

    for file in "${files[@]}"
    do
        # Enable Systemd Services
        systemctl enable $(basename "${file}")

        # Restart Systemd Services
        systemctl restart $(basename "${file}")
    done

    # Chown
    chown -R root:root /etc/networking-snid/

    # Ensure Executable Permission
    chmod +x /etc/networking-snid/*.sh
fi

if [[ "${SETUP_CONTAINERS_NETWORKING}" == "yes" ]]
then
    # Rename Folders if they exists Already
    if [[ -d "/etc/containers-networking" ]]
    then
        mv /etc/containers-networking /etc/networking-containers
    fi

    # Remove Previous Scripts that have been converted to Symlink
    if [[ -f "/etc/networking-containers/functions.sh" ]]
    then
        rm -f "/etc/networking-containers/functions.sh"
    fi

    # Create Folders if they don't exist yet
    mkdir -p /etc/networking-containers

    # Symlink to common functions.sh File
    cd /etc/networking-containers || exit
    ln -s ../networking-general/functions.sh functions.sh

    # Create Directory Structor for containers
    mkdir -p /etc/networking-containers
    mkdir -p /etc/networking-containers/routes.local.d

    # Remove Renamed Systemd File
    rm -f /etc/systemd/system/container-routes.service

    # Copy Scripts
    cp ${toolpath}/etc/networking-containers/*.sh /etc/networking-containers/

    # Copy Systemd Services
    cp ${toolpath}/etc/systemd/system/containers-*.service /etc/systemd/system/

    # Reload Systemd Daemon
    systemctl daemon-reload
    systemctl daemon-reexec

    # Find matching Services
    mapfile -t files < <( find "/etc/systemd/system/" -iname "containers-*.service" | grep $(basename) )

    for file in "${files[@]}"
    do
        # Enable Systemd Services
        systemctl enable $(basename "${file}")

        # Restart Systemd Services
        systemctl restart $(basename "${file}")
    done

    # Chown
    chown -R root:root /etc/networking-containers/

    # Ensure Executable Permission
    chmod +x /etc/networking-containers/*.sh
fi

# Reload Systemd Daemon
systemctl daemon-reload
