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
FORCE=$5
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

read -p "CONFIGURE local setting?" yn;
case $yn in
	[Yy]* )
			echo "alias ls=\"ls --color\"" >> $HOME/.bashrc;
			touch $HOME/.vimrc;
			cat ":syntax on" >> $HOME/.vimrc;
			;;
	[Nn]* );;
	*) echo "Please answer y or n" ;;
esac
echo "CONFIGURE local setting DONE";
# ---------------------------------------------------------------------------#
# 1. Need to mount the LVM disk as ext3 disk
# Reference: http://lukasz.cepowski.com/devlog/38,ovh-xenserver-convert-from-lvm-to-ext3

#cat /proc/partitions
#xe pbd-list sr-uuid=$SR_UUID
#xe host-list
read -p "CONFIGURE LOCAL DISK ?" yn
case $yn in
	[Yy]* )
			xe pbd-unplug uuid=$PBD_UUID;
			xe pbd-destroy uuid=$PBD_UUID;
			xe sr-forget uuid=$SR_UUID;
			xe sr-create host-uuid=$HOST_UUID shared=false type=ext content-type=user device-config:device=$DEV_PATH name-label="RAID1";
			#TODO make the returning string of the last command as the NEW_SR_UUID
			;;
	[Nn]* );;
	*) echo "Please answer y or n" ;;
esac

cd $HOME


# TODO: Also, need to set the default SR for xenserver.
# xe pool-list
# xe pool-param-set uuid=<pool-uuid> default-SR=$NEW_SR_UUID


#-----------------------------#
# 2. Install git
# Reference: http://xenapiadmin.com/39-install-git-on-xcp-1-6
read -p "INSTALL git ?" yn
case $yn in
	[Yy]* )
			rpm -ivh http://mirror.itc.virginia.edu/fedora-epel/5/i386/epel-release-5-4.noarch.rpm
			yum --enablerepo=base --disablerepo=citrix install traceroute
			yum install vim
			yum install git
			sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/epel.repo
			;;
	[Nn]* );;
	*) echo "Please answer y or n" ;;
esac


#-----------------------------#
# 3. Install xen api plugins
# Reference: https://wiki.openstack.org/wiki/XenServer/PostInstall
NOVA_DIR=nova
PLUGIN_DEST=/etc/xapi.d/plugins
read -p "INSTALL xen openstack api" yn
case $yn in
	[Yy]* )
			git clone https://github.com/openstack/nova.git
			cd $NOVA_DIR/plugins/xenserver/xenapi/etc/xapi.d/plugins
			cp * $PLUGIN_DEST
			chmod a+x $PLUGIN_DEST/
			;;
	[Nn]* );;
	*) echo "Please answer y or n" ;;
esac

cd $HOME

#-----------------------------#
# 4. Make a Required storage
# Reference: https://wiki.openstack.org/wiki/XenServer/PostInstall
read -p "make a new required storage" yn
case $yn in
	[Yy]* )
			mkdir /images
			;;
	[Nn]* );;
	*) echo "Please answer y or n" ;;
esac


#-----------------------------#
# 5. Install python 2.6
# Reference: https://wiki.openstack.org/wiki/XenServer/PostInstall
# This may not work, need to find a new way to do it.
# wget http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
# rpm -ivh epel-release-5-4.noarch.rpm
read -p "INSTALL python2.6 ?" yn
case $yn in
	[Yy]* )
			wget http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
			rpm -Uvh epel-release-5-4.noarch.rpm
			yum install python26-distribute
			rpm -ev epel-release
			rm -f epel-release-5-4.noarch.rpm
			;;
	[Nn]* );;
	*) echo "Please answer y or n" ;;
esac


#-----------------------------#
# 6. Install pip and python-swiftclient & python-keystone client
# Reference: https://wiki.openstack.org/wiki/XenServer/PostInstall
read -p "INSTALL pip and python openstack client ?" yn
case $yn in
	[Yy]* )
			easy_install-2.6 pip
			pip install python-swiftclient python-keystoneclient
			;;
	[Nn]* );;
	*) echo "Please answer y or n" ;;
esac

#-----------------------------#
# 7. get devstack
read -p "git clone devstack?" yn
case $yn in
	[Yy]* )
			if [-d "devstack"]; then
				echo "You already have devstack";;	
			else
				git clone https://github.com/openstack-dev/devstack
			fi
			;;
	[Nn]* );;
	*) echo "Please answer y or n";;
esac

# 8. 
# TODO:
#-- Need to add SR for OpenStack Glance Image storage --#

#-- --#

exit;
