#!/bin/bash

# The action (start/stop) is in the global variable $action

# Setup Route
setup_route_general() {
    # Input Arguments
    local lcmd="$1"
    local ltype="$2"
    local lroute="$3"
    local lgw="$4"
    local lmetric="${5:-256}"

    # Initialize Variables
    local lexitcode
    local loutputmessage
    local ldescription
    local lrouteinfo

    # Generate Command Description
    if [[ "${lcmd}" == "replace" ]]
    then
       ldescription="Adding/Replacing"
    elif [[ "${lcmd}" == "del" ]]
    then
       ldescription="Deleting"
    else
       # Echo
       echo "[ERROR]: Command {lcmd} is NOT valid! Must be one of [replace, del]. Abort !"
       exit 1
    fi

    # Add/Delete Route
    if [[ "${ltype}" == "external" ]]
    then
        # Echo
        echo "Adding/Replacing Route for <${lroute}> via <${lgw}> metric <${lmetric}>"

        # Configure Route
        loutputmessage=$(ip route ${lcmd} ${lroute} via ${lgw} metric ${lmetric} 2>&1)
    elif [[ "${ltype}" == "local" ]]
    then
        # Echo
        echo "Adding/Replacing Route for <${lroute}> dev <lo> metric <${lmetric}>"

        # Configure Route
        loutputmessage=$(ip route ${lcmd} local ${lroute} dev lo metric ${lmetric} 2>&1)
    else
        echo "[ERROR]: Invalid Route Type <${ltype}>"
        exit 2
    fi

    # Store Exit Code
    lexitcode=$?

    # Check if Route failed to be added
    if [ ${lexitcode} -ne 0 ]
    then
        echo "[WARNING]: {ldescription} Route failed with the following Message: ${loutputmessage}"

        if [[ "${loutputmessage}" == "RTNETLINK answers: No route to host" ]]
        then
            if [[ "${ltype}" == "external" ]]
            then
                # Manually Configure Host as a Nexthop

                # Find which Gateway the Host uses
                lrouteinfo=$(ip route get "${lgateway}" | head -1)

                # Find which Device we need to configure the Host as a Nexthop for
                local lroutedevice=$(echo "${lrouteinfo}" | sed -E "s|^.*?dev\s([0-9a-zA-Z]*?)\s*.*$|\1|g")

                # Echo
                echo "Setup Host <${lgw}> as a Nexthop on Interface <${lroutedevice}>"

                # Configure Nexthop
                ip route add ${lgw} dev ${lroutedevice} metric ${lmetric}

                # Echo
                echo "Adding/Replacing Route for <${lroute}> via <${lgw}> metric <${lmetric}>"

                # Configure Route
                loutputmessage=$(ip route ${lcmd} ${lroute} via ${lgw} metric ${lmetric} 2>&1)
            fi
        fi
    fi
}

# Setup Route
setup_route() {
    # Input Arguments
    local ltype="$1"
    local lroute="$2"
    local lgw="$3"
    local lmetric="${4:-256}"

    # Initialize Variables
    local lexitcode
    local loutputmessage
    local lcmd

    # Define which Action to perform
    if [[ "${action}" == "start" ]]
    then
        # Use ip <replace> Command (can be used both to add and replace Routes)
        lcmd="replace"
    elif [[ "${action}" == "stop" ]]
    then
        # Use ip <del> Command
        lcmd="del"
    else
        # Echo Error
        echo "[ERROR]: Invalid Action <${action}>"
    fi

    # Setup Route
    setup_route_general "${lcmd}" "${ltype}" "${lroute}" "${lgw}" "${lmetric}"
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
