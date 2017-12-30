#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [ -z "$1" ]
  then
    echo "IP is required. Example: $0 192.168.1.10"
    exit 1
fi

IP=$1

if [[ $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "IP $IP is valid"
else
  echo "This is not a valid IP, please use a valid IP number."
fi

### Stop Docker, clear IPTables and start again ###

echo "* Stopping FirewallD"
systemctl stop firewalld
echo "* Flusing IP Tables"
iptables -F
iptables -X
echo "Restarting Docker Daemon"
systemctl restart docker

# Now lets start OC Cluster UP

echo "Starting Openshift All In One cluster, follow the instructions to login and access cli and Web portal"
oc cluster up --public-hostname=openshift.$IP.nip.io --routing-suffix=apps.$IP.nip.io
