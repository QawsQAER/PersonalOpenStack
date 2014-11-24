#!/bin/bash

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install gcc g++ git

DEVSTACK_DIR=devstack
git clone https://github.com/openstack-dev/devstack.git $DEVSTACK_DIR

cd $DEVSTACK_DIR




