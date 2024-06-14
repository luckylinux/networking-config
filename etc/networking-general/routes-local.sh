#!/bin/bash

# Action
action=${1-"start"}

# Get list of Configuration Scripts
mapfile -t files < <( find "/etc/networking-general/routes.local.d/" -iname "*.sh" )

# Process each File
for file in "${files[@]}"
do
   # Process File
   source $file
done

# Return Exit Code 0 by Default
exit 0
