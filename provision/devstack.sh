#!/bin/bash

ADMIN_PASSWORD=secret
HOST_IP=`ifconfig enp0s3 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`

sudo apt-get update

sudo useradd -s /bin/bash -d /opt/stack -m stack

echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack

sudo -u stack git clone https://git.openstack.org/openstack-dev/devstack /opt/stack/devstack

sudo -u stack cat << EOF > /opt/stack/devstack/local.conf
[[local|localrc]]
HOST_IP=$HOST_IP
ADMIN_PASSWORD=$ADMIN_PASSWORD
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD
EOF

sudo -u stack /opt/stack/devstack/./stack.sh
