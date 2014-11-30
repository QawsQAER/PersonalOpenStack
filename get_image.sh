#!/bin/bash
source ~/devstack/openrc admin admin
glance image-create \
	--name UbuntuTrusty \
	--disk-format qcow2 \
	--container-format bare \
	--is-public True \
	--copy-from http://uec-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img
glance image-create \
        --name UbuntuTrustyVanilla2.4.1 \
        --disk-format qcow2 \
        --container-format bare \
        --is-public True \
        --copy-from http://sahara-files.mirantis.com/sahara-juno-vanilla-2.4.1-ubuntu-14.04.qcow2
glance image-create \
        --name UbuntuTrustySpark1.0 \
        --disk-format qcow2 \
        --container-format bare \
        --is-public True \
        --copy-from http://sahara-files.mirantis.com/sahara-juno-spark-1.0.0-ubuntu-14.04.qcow2
