#!/bin/bash

#--------------------------------------------------------------
# Variables
#--------------------------------------------------------------
ADMIN_PASSWORD=secret
HOST_IP=`ifconfig enp0s8 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`
BRANCH='master'
#--------------------------------------------------------------

#--------------------------------------------------------------
# System update and tune
#--------------------------------------------------------------
sudo apt-get update
#--------------------------------------------------------------

#--------------------------------------------------------------
# SWAP File
#--------------------------------------------------------------
# size of swapfile in megabytes

#swapsize=4000

# does the swap file already exist?
#grep -q "swapfile" /etc/fstab

# if not then create it
#if [ $? -ne 0 ]; then
#  echo 'swapfile not found. Adding swapfile.'
#  fallocate -l ${swapsize}M /swapfile
#  chmod 600 /swapfile
#  mkswap /swapfile
#  swapon /swapfile
#  echo '/swapfile none swap defaults 0 0' >> /etc/fstab
#else
#  echo 'swapfile found. No changes made.'
#fi

# output results to terminal
#df -h
#cat /proc/swaps
#cat /proc/meminfo | grep Swap
#--------------------------------------------------------------


#--------------------------------------------------------------
# Devstack setup
#--------------------------------------------------------------
sudo useradd -s /bin/bash -d /opt/stack -m stack

echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack

sudo -u stack git clone -b $BRANCH https://git.openstack.org/openstack-dev/devstack /opt/stack/devstack

sudo -u stack cat << EOF > /opt/stack/devstack/local.conf
[[local|localrc]]
#
# Enabled plugins
#-----------------
#enable_plugin congress https://git.openstack.org/openstack/congress
#enable_plugin monasca https://git.openstack.org/openstack/monasca-api
#enable_plugin contrail https://github.com/zioc/contrail-devstack-plugin.git
enable_plugin trove git://git.openstack.org/openstack/trove
#
# Services configuration
#------------------------
#FLAT_INTERFACE=enp0s3
HOST_IP=$HOST_IP
ADMIN_PASSWORD=$ADMIN_PASSWORD
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD
EOF

#sudo su - stack
#cd /opt/stack/devstack
#./stack.sh
sudo su - stack -c 'cd ~/devstack && ./stack.sh'
#--------------------------------------------------------------
