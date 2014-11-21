#!/bin/bash
source ~/devstack/openrc admin admin
glance image-create \
	--name UbuntuTrusty \
	--disk-format qcow2 \
	--container-format bare \
	--is-public True \
	--copy-from http://uec-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img