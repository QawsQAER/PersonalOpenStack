#!/bin/bash

DEVSTACK_DIR=$HOME/devstack
if [ ! -d $DEVSTACK_DIR ]
then
	echo "You must have devstack in the home directory"
	exit;
fi

cd $DEVSTACK_DIR;
if [ ! -f $DEVSTACK_DIR/localrc ] || [ ! -f $DEVSTACK_DIR/local.conf ]
then
	echo "You must have your configuration file in devstack directory";
	exit;
fi

source stack.sh
source get_image.sh
