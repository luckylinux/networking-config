#!/bin/bash

# Action
action=${1-"start"}

# Load Functions
source /etc/containers-networking/functions.sh

# Setup Local Routes
# Range 2001:0db8:0000:0001:0000:0000:ff15:0000 - 2001:0db8:0000:0001:0000:0000:ff15:ffff can be automatically configured by Podman User
setup_local_route "2001:db8:0000:0001:0000:0000:ff15:0000/112"

