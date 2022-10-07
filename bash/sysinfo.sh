#!/bin/bash
#My lab 2 script improved sysinfo.sh
#gathering all the data
fqdn=$(hostname -f)
osname=$(cat /etc/os-release | grep -w NAME)
osversion=$(cat /etc/os-release | grep -w VERSION)
ipaddress=$(ip a s ens33 | grep -w inet | awk '{print $2}' | sed -e 's,/..*,,')
availablespace=$(df -h --output=avail / |grep Avail -v) 
#for outputemplate
cat <<EOF
"Report for $HOSTNAME"
======================
FQDN: $fqdn
Operating System name and version : $osname and $osversion
IP Address : $ipaddress
Root Filesystem Free Space: $availablespace
======================
EOF

