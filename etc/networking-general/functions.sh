#!/bin/bash

# The action (start/stop) is in the global variable $action

# Setup Route
setup_route() {
    # Arguments
    local ltype="$1"
    local lroute="$2"
    local lgw="$3"

    if [[ "${action}" == "start" ]]
    then
        if [[ "${ltype}" == "external" ]]
        then
            # Echo
            echo "Adding/Replacing Route for <${lroute}> via <${lgw}>"

            # Add/Replace Route
            ip route replace ${lroute} via ${lgw}
        elif [[ "${ltype}" == "local" ]]
        then
            # Echo
            echo "Adding/Replacing Route for <${lroute}> dev <lo>"

            # Add/Replace Route
            ip route replace local ${lroute} dev lo
        else
            echo "[ERROR]: Invalid Route Type <${ltype}>"
        fi
    elif [[ "${action}" == "stop" ]]
    then
        if [[ "${ltype}" == "external" ]]
        then
            # Echo
            echo "Removing Route for <${lroute}> via <${lgw}>"

            # Delete Route
            ip route del ${lroute} via ${lgw}
        elif [[ "${ltype}" == "local" ]]
        then
            # Echo
            echo "Adding/Replacing Route for <${lroute}> dev <lo>"

            # Delete Route
            ip route del local ${lroute} dev lo
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
