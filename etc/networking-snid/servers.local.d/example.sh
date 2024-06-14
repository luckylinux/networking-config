#!/bin/bash

#!/bin/bash

# Wait a bit until System is properly booted up
sleep 15

# Configuration
IPV4_ADDRESS="192.168.8.25"
IPV4_PORT="443"
IPV4_TYPE="tcp"
NAT46_PREFIX="64:ff9b:1::9999:0:0"
IPV6_BACKEND_CIDR="2001:db8:0000:0001:0000:0000:0001:0000/112"

# Echo
echo "Starting snid Server: Listening on ${IPV4_TYPE}:${IPV4_ADDRESS}:${IPV4_PORT}. Using NAT46 Prefix ${NAT46_PREFIX} with CIDR Backend ${IPV6_BACKEND_CIDR}"

# Run the Server
/opt/snid/snid -listen "${IPV4_TYPE}":"${IPV4_ADDRESS}":"${IPV4_PORT}" -mode nat46 -nat46-prefix "${NAT46_PREFIX}" -backend-cidr "${IPV6_BACKEND_CIDR}"
