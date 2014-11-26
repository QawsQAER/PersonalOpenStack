#!/bin/bash
source ~/devstack/openrc admin admin

# Reference 
#http://docs.openstack.org/developer/sahara/userdoc/vanilla_plugin.html
glance image-create \
	--name UbuntuTrustyVanilla2.4.1 \
	--disk-format qcow2 \
	--container-format bare \
	--is-public True \
	--copy-from http://sahara-files.mirantis.com/sahara-juno-vanilla-2.4.1-ubuntu-14.04.qcow2 
