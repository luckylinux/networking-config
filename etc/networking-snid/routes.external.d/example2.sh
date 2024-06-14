#!/bin/bash

# Action
action=${1-"start"}

# Load Functions
source /etc/networking/functions.sh

# Setup External Routes
setup_external_route "64:ff9b:1::2:0:0/96" "2001:db8:0000:0001:0000:0000:0001:0102"
