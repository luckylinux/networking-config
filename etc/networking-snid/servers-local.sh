#!/bin/bash

# Action
action=${1-"start"}

# Get list of Configuration Scripts
mapfile -t files < <( find "/etc/networking-snid/servers.local.d/" -iname "*.sh" )

# Process each File
for file in "${files[@]}"
do
   # Process File
   source $file
done
