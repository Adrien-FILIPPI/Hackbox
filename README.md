Hackbox

La hackbox est un dispositif d'audit de sécurité depuis une Raspberry Pi permettant de générer un rapport du SI.

##Installation de Kali sur la Raspberry et configuration de l'écran

https://whitedome.com.au/re4son/sticky-fingers-kali-pi/

##Placer le répertoire de la hackbox dans /opt/

##Vous pouvez modifier le menu par défaut, ou le remplacer par le mien qui se trouve dans /opt/hackbox/Menus. Le menu de la raspberry se trouve par défaut dans /home/pi/Kali-Pi/Menus

##Supprimer le fichier ip.txt au demarrage

Ajouter à /etc/rc.local (avant le exit 0) la ligne : rm /opt/hackbox/report/ip.txt

##Recuperer en temps réel l'IP depuis ifconfig

Donner les droits d'écritures pour le dossier /opt/hackbox/report: chmod -R 777 /opt/hackbox/report

Ecrire dans le .bashrc (root et pi):

while true do /opt/hackbox/scripts/getrealip.sh sleep 1 done &

##Personnalisation des menus

Les commandes sont appelées dans /home/pi/Kali-Pi/Menus/menu-x.py Des fonctions ont été modifiées dans /home/pi/Kali-Pi/Menus/kalipy.py

##Dans .bashrc alias menu='/home/pi/Kali-Pi/menu'
