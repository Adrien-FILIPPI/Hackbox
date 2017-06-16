#!/bin/bash

if /sbin/ifconfig eth0 | grep -q 'inet '
then
    realip=$(/sbin/ifconfig eth0 | grep 'inet ' | awk '{ print $2}')
    echo "${realip}" > /opt/hackbox/scripts/realip.txt
else
    echo "Pas d'IP : eth0" > /opt/hackbox/scripts/realip.txt
fi