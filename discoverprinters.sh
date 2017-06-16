#!/bin/bash

# if [ ! -d "/opt/hackbox/report/web/printers" ];
# then
#     mkdir /opt/hackbox/report/web/printers
# fi

ip=$(cat /opt/hackbox/report/ip.txt |cut -d'.' -f-3)
ip="$ip.1-254"
nmap -O -oX /opt/hackbox/report/web/discoverprinters.xml -p9100 --open ${ip}
xsltproc /opt/hackbox/report/web/discoverprinters.xml --output /opt/hackbox/report/web/discoverprinters.html
rm /opt/hackbox/report/web/discoverprinters.xml

# echo -e "\033[34m\033[1mList of printers available in /opt/hackbox/report/printers/printerslist\033[0m"
# cat /opt/hackbox/loot/printers/printerslist.txt | grep "report" | awk '{ print $5}' > /opt/hackbox/loot/printers/printersip.txt
# echo -e "\033[34m\033[1mList of IPs available in /opt/hackbox/loot/printers/printersip.txt\033[0m"
# echo -e "\033[31m\033[1mDone... Ready to attack with PRET\033[0m"

# i=1
# j=0
# attacklanguagetab=('ps' 'pjl' 'pcl')
# for line in $(cat /opt/hackbox/loot/printers/printersip.txt)
# do
#     for j in 0 1 2
#     do
#         if [ ${attacklanguagetab[j]} = "ps" ]
#         then
#             echo "$line" | awk '{print $0, "ps"}' > /opt/hackbox/loot/printers/${i}${attacklanguagetab[j]}
#         fi
#         if [ ${attacklanguagetab[j]} = "pjl" ]
#         then
#             echo "$line" | awk '{print $0, "pjl"}' > /opt/hackbox/loot/printers/${i}${attacklanguagetab[j]}
#         fi
#         if [ ${attacklanguagetab[j]} = "pcl" ]
#         then
#             echo "$line" | awk '{print $0, "pcl"}' > /opt/hackbox/loot/printers/${i}${attacklanguagetab[j]}
#         fi
#     done
#     let "i=$i + 1"
# done
#
# echo -e "\033[34m\033[1mDone... Ready to attack with PRET\033[0m"
#
# echo -e "\033[32m\033[1m###PRET Attack###\033[0m"
# echo -e "\033[32m\033[1mUsage example : /opt/PRET-master/pret.py \$(cat /opt/hackbox/loot/printers/1ps.txt)\033[0m"
# echo -e "\033[32m\033[1mIf you have a timeout, just remove the file\033[0m"






