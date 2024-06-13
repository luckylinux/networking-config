#!/bin/bash

# Action
action=${1-"start"}

# Process each File
for file in /etc/containers-networking/addresses.local.d/*.sh
do
   # Process File
   source $file
done
