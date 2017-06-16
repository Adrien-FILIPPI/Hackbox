#!/usr/bin/python
import sys
import shlex
import subprocess as sub
import os
import netifaces as ni
from colorama import init, Fore, Back, Style

init(autoreset=True)

# Are you root ?
if not os.geteuid() == 0:
    print(Fore.RED + "*** YOU MUST BE ROOT...***")
    sys.exit(-1)

# Sniff to find Ip Class of LAN
cmd_tcpdump = "/usr/sbin/tcpdump -l -n -c 1 -i eth0 ip"
args = shlex.split(cmd_tcpdump)
# execute tcpdump command and write in tcpdump.txt
with open("tcpdump.txt", "wb") as tcpdump, open("stderr.txt", "wb") as err:
    sub.Popen(args, stdout=tcpdump, stderr=err).wait()

# Split to find IP
textfile = open('tcpdump.txt', 'r')
filetext = textfile.read()
textfile.close()
# matches = re.findall( r'[0-9]+(?:\.[0-9]+){2}', filetext )
motip = filetext.split("IP")[1]
listeip = motip.split(".")
magicip = listeip[0]
magicip = magicip + "." + listeip[1]
magicip = magicip + "." + listeip[2] + "."
print(Fore.GREEN + "Lan discovery:")
print(magicip)

# Arping while IP is occupied:
num = 1
rep = 0
while rep == 0:
    adresse = magicip + str(num)
    sub.Popen('if arping -I eth0 -c 1' + adresse + '| grep "Received 0 response(s)"; then export rep="1"; fi',
              shell=True)
    rep = os.environ["rep"]
    print(rep)
    if rep == 0:
        print(Fore.RED + "arping to" + adresse + " seems to be OCCUPIED...")
        num = num + 1
    else:
        print(Fore.YELLOW + "no response from" + adresse)
        print(Fore.GREEN + "arping to" + adresse + " seems to be FREE :-)")
print("The Ip to use is " + adresse)
os.system('ifconfig eth0 down')
print(Fore.GREEN + "New Mac address for the Raspberry...")
os.system('macchanger -r eth0')
os.system("ifconfig eth0 " + adresse + " netmask 255.255.255.0")
os.system('ifconfig eth0 up')
ni.ifaddresses('eth0')
ip = ni.ifaddresses('eth0')[2]
print("New Ip parameter for the Raspberry...")
print(ip)

# Now it's time take Recon ;-)
