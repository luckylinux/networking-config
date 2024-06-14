#!/bin/bash

# Action
action=${1-"start"}

# Load Functions
source /etc/snid/functions.sh

# Setup Local Routes
setup_local_route "64:ff9b:1::9999:0:0/96"
