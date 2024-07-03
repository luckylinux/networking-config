#!/bin/bash

# Action
action=${1-"start"}

# Wait a bit until System is properly booted up
delay_script_startup "SNID Local Routes Service"

# Get list of Configuration Scripts
mapfile -t files < <( find "/etc/networking-snid/routes.local.d/" -iname "*.sh" )

# Process each File
for file in "${files[@]}"
do
   # Process File
   source $file
done

# Return Exit Code 0 by Default
exit 0
