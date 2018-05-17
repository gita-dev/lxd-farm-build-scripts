#!/bin/sh

ifconfig tap-virt-net up
brctl addif lxd-cluster-02 tap-virt-net
/etc/firewall.sh

exit 0