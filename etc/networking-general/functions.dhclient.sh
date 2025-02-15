#!/bin/bash

# <interface> is a global variable
# <reason> is a global variable
# This refers to which interface is being brought up/down

add_static_route() {
   local lnetwork="$1"
   local lnetmask="$2"
   local lgateway="$3"

   # Echo the reason for the invocation
   #echo "Reason for calling function: ${reason}"

   # Check first of all if interface exists in /sys/class/net/${interface}/ifindex
   # Exit otherwise
   if [ ! -e "/sys/class/net/${interface}/ifindex" ]
   then
      exit 0
   fi

   # Check if Routes are Applicable
   #ip route show to match $lgateway
   local lrouteinfo=$(ip route get "${lgateway}" | head -1)

   # Check
   #local lnetworkdevice=$(echo $lrouteinfo | sed -E "s|^.*?dev ([0-9a-zA-Z]*?)\s*.*$|\1|g")
   local lroutedevice=$(echo "${lrouteinfo}" | sed -E "s|^.*?dev\s([0-9a-zA-Z]*?)\s*.*$|\1|g")

   # If reason is either of: REBOOT, RENEW, REBIND
   if [ "${reason}" = "REBOOT" ] || [ "${reason}" = "RENEW" ] || [ "${reason}" = "REBIND" ]
   then

      # If this route is through the specified interface, let's add it, otherwise ignore it
      if [ "${interface}" = "${lroutedevice}" ]
      then
         # Echo the adding of the Static Route
         echo "Adding Static Route Configuring for interface ${interface}: ${lnetwork}"/"${lnetmask} via ${lgateway} dev ${interface}"

         # !! We should NOT add the static route if the gateway addresses matches this System !!
         # https://stackoverflow.com/questions/12523872/bash-script-to-get-all-ip-addresses
         local lsystemip=$(ip -4 -o addr show scope global | awk '{gsub(/\/.*/,"",$4); print $4}' | grep "${lgateway}")

         # Check if System matches Gateway IP address
         if [ -z "${lsystemip}" ]
         then
            # Add Route
            ip route add "${lnetwork}"/"${lnetmask}" via "${lgateway}" dev "${interface}"
         fi
      fi
   fi
}
