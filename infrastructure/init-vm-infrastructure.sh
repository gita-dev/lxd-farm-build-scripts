#!/bin/sh

mkdir /var/lib/lxd/storage-pools/default
lxc storage create default dir
lxc profile device add default root disk path=/ pool=default
lxc profile device remove default eth0
