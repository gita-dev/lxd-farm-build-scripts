#!/bin/sh

proc_check=`/bin/ps ax | grep "/usr/local/bin/lxd" | grep -v "grep" | head -n 1`

# Check process exist
while [ -z "$proc_check" ]; 
    do
    proc_check=`/bin/ps ax | grep "/usr/local/bin/lxd" | grep -v "grep" | head -n 1`
    sleep 5
    done

# Check socket exist
while [ ! -S "/var/lib/lxd/unix.socket" ]; 
    do
    sleep 5
    done

cat /opt/LXD-FARM-MANAGER/manager/autorun-lxc.dat | grep -v "^$" | while read line;
    do
    lxc start $line
    done


