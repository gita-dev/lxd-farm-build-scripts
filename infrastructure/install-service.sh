#!/bin/sh

cp ./lxd.service /lib/systemd/system/lxd.service
systemctl enable lxd
systemctl start lxd