#!/bin/sh

## This script update the hostname to '<img-name>-<mac addr of eth0>' if the hostname is not seted or 'localhost' 
fullname="$imgname${box_branch:+-$box_branch}${box_version:+-$box_version}"
[ ! -f /newroot/etc/hostname ] && (echo -n "$fullname." && cat /sys/class/net/eth0/address | sed 's/:/-/g') > /newroot/etc/hostname
[ $(cat /newroot/etc/hostname) == "localhost" ] && (echo -n "$fullname." && cat /sys/class/net/eth0/address | sed 's/:/-/g') > /newroot/etc/hostname
