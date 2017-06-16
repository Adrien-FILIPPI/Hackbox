#!/bin/bash

#####Découverte d'hôtes actifs avec nmap#####

ip=$(cat /opt/hackbox/report/ip.txt |cut -d'.' -f-3)
ip="$ip.1-254"

nmap -T4 -A -sT -O -oX /opt/hackbox/report/web/nmap.xml -p- $ip
xsltproc /opt/hackbox/report/web/nmap.xml --output /opt/hackbox/report/web/nmap.html
rm /opt/hackbox/report/web/nmap.xml

echo -e "\033[34m\033[1mReport of the scan in /opt/hackbox/report/web/nmap.html\033[0m"


/usr/bin/xfce4-session-logout --logout