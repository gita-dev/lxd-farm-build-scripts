#!/bin/sh

ifconfig tap-gita-virt up
brctl addif lxd-cluster-01 tap-gita-virt
/etc/firewall.sh

exit 0