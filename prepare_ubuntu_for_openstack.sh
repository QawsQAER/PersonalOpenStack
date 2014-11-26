#!/bin/bash
# This script will try to prepare the newly installed ubuntu distribution for Openstack
# before it can execute devstack's script 
cd $HOME

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install gcc g++ git openssh-server vim

DEVSTACK_DIR=$HOME/devstack
if [ ! -d $DEVSTACK_DIR ]
then 
	git clone https://github.com/openstack-dev/devstack.git $DEVSTACK_DIR
fi

if [ ! -f $DEVSTACK_DIR/localrc ] || [ ! -f $DEVSTACK_DIR/local.conf]
then
	echo "You must have a localrc or local.conf file";
	exit;
fi;


