#!/bin/bash

# This script is written by Edward HUANG, huangxx_2155@live.com
# Try to make the installation preparation of OpenStack on XenServer Dom0 eaiser
# Many of the following content comes from internet

#!
#! WARNING: THIS SCRIPT COMES WITHOUT WARRANTY, USE WITH CAUTION
#!



HOST_UUID=$1
SR_UUID=$2
PBD_UUID=$3
DEV_PATH=$4
CUR_USR=`whoami`

if [ $CUR_USR == "root" ]
then
	echo "Executing script as root";
else
	echo "Error: This script should be executed as root";
	exit;
fi

if [[ $HOST_UUID && $SR_UUID && $PBD_UUID && $DEV_PATH ]]
then
	echo "HOST_UUID=${HOST_UUID}";
	echo "SR_UUID=${SR_UUID}";
	echo "PBD_UUID=${PBD_UUID}";
	echo "DEV_PATH=${DEV_PATH}";
else
	echo "Error: You should provide HOST_UUID SR_UUID, PBD_UUID, DEV_PATH as the arguments"
	exit;
fi


exit;

# ---------------------------------------------------------------------------#
# 1. Need to mount the LVM disk as ext3 disk
# Reference: http://lukasz.cepowski.com/devlog/38,ovh-xenserver-convert-from-lvm-to-ext3

#xe pbd-list sr-uuid=$SR_UUID
xe pbd-unplug uuid=$PBD_UUID
xe pbd-destroy uuid=$PBD_UUID
xe sr-forget uuid=$SR_UUID
#xe host-list
xe sr-create host-uuid=$HOST_UUID shared=false type=ext content-type=user device-config:device=$DEV_PATH name-label="RAID1"

cd $HOME

#-----------------------------#
# 2. Install git
# Reference: http://xenapiadmin.com/39-install-git-on-xcp-1-6

rpm -ivh http://mirror.itc.virginia.edu/fedora-epel/5/i386/epel-release-5-4.noarch.rpm
yum install git

sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/epel.repo

#-----------------------------#
# 3. Install xen api plugins 
# Reference: https://wiki.openstack.org/wiki/XenServer/PostInstall
$NOVA_DIR=nova
$PLUGIN_DEST=/etc/xapi.d/plugins

git clone https://github.com/openstack/nova.git
cd $NOVA_DIR/plugins/xenserver/xenapi/etc/xapi.d/plugins
cp * $PLUGIN_DEST
chmod a+x $PLUGIN_DEST/

cd $HOME

#-----------------------------#
# 4. Make a Required storage
# Reference: https://wiki.openstack.org/wiki/XenServer/PostInstall
mkdir /images

#-----------------------------#
# 5. Install python 2.6
# Reference: https://wiki.openstack.org/wiki/XenServer/PostInstall

wget http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
rpm -Uvh epel-release-5-4.noarch.rpm
yum install python26-distribute
rpm -ev epel-release
rm -f epel-release-5-4.noarch.rpm

#-----------------------------#
# 6. Install pip and python-swiftclient & python-keystone client
# Reference: https://wiki.openstack.org/wiki/XenServer/PostInstall 
easy_install-2.6 pip
pip install python-swiftclient python-keystoneclient

#-----------------------------#
# 7. Add a user openstack to sudoer
# 
adduser openstack
passwd openstack
echo "openstack ALL=(ALL:ALL)	ALL" >> /etc/sudoers


exit;