# This script will try to resume OpenStack running enviornment after reboot

#https://ask.openstack.org/en/question/5423/rebooting-with-devstack/

sudo losetup -f /opt/stack/data/stack-volumes-backing-file

source ~/devstack/rejoin-stack.sh
