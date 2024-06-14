#!/bin/bash

# Run the Server
/opt/snid/snid -listen tcp:192.168.8.25:443 -mode nat46 -nat46-prefix 64:ff9b:1::9999:0:0 -backend-cidr 2001:db8:0000:0001:0000:0000:0001:0000/112
