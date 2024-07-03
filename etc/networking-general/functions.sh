#!/bin/bash

# The action (start/stop) is in the global variable $action

# Setup Route
setup_route() {
    # Arguments
    local ltype="$1"
    local lroute="$2"
    local lgw="$3"
    local lmetric="${4:-256}"

    if [[ "${action}" == "start" ]]
    then
        if [[ "${ltype}" == "external" ]]
        then
            # Echo
            echo "Adding/Replacing Route for <${lroute}> via <${lgw}> metric <${lmetric}>"

            # Add/Replace Route
            ip route replace ${lroute} via ${lgw} metric ${lmetric}
        elif [[ "${ltype}" == "local" ]]
        then
            # Echo
            echo "Adding/Replacing Route for <${lroute}> dev <lo> metric <${lmetric}>"

            # Add/Replace Route
            ip route replace local ${lroute} dev lo metric ${lmetric}
        else
            echo "[ERROR]: Invalid Route Type <${ltype}>"
        fi
    elif [[ "${action}" == "stop" ]]
    then
        if [[ "${ltype}" == "external" ]]
        then
            # Echo
            echo "Removing Route for <${lroute}> via <${lgw}> metric <${lmetric}>"

            # Delete Route
            ip route del ${lroute} via ${lgw} metric ${lmetric}
        elif [[ "${ltype}" == "local" ]]
        then
            # Echo
            echo "Adding/Replacing Route for <${lroute}> dev <lo> metric <${lmetric}>"

            # Delete Route
            ip route del local ${lroute} dev lo metric ${lmetric}
        else
            echo "[ERROR]: Invalid Route Type <${ltype}>"
        fi
    else
        # Echo Error
        echo "[ERROR]: Invalid Action <${action}>"
    fi

}


# Setup External Route
setup_external_route() {
    setup_route "external" ${*}
}

# Setup Local Route
setup_local_route() {
    setup_route "local" ${*}
}

# Delayed Startup
delay_script_startup() {
   local ldescription="$1"
   local ldelay="${2:-30}"

   # Wait a bit until System is properly booted up
   if [[ "${action}" == "start" ]]
   then
       echo "Starting ${ldescription}"
       echo "Waiting ${ldelay} seconds to make sure that Networking is Properly UP"
       sleep ${ldelay}
   fi
}
