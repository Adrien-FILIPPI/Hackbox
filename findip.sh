#!/usr/bin/env bash

# Are you root ?
if [[ $EUID -ne 0 ]]; then
   echo -e "\033[31m\033[1mThis script must be run as root\033[0m"
   exit 1
fi

ifconfig eth0 0.0.0.0

###Supprime le fichier contenant l'ip###
if [ -e /opt/hackbox/report/ip.txt ]; then
    rm /opt/hackbox/report/ip.txt
fi

###Création du rapport HTML
touch /opt/hackbox/report/web/findip.html
echo '<!DOCTYPE html>
<html lang="fr">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Hackbox Report</title>

    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="css/landing-page.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesnt work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-fixed-top topnav" role="navigation">
        <div class="container topnav">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand topnav" href="index.html">Hackbox Report</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li>
                        <a href="#about">About</a>
                    </li>
                    <li>
                        <a href="#contact">Contact</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

<div class="content-section-a">

        <div class="container">

            <div class="row">
                <div class="col-lg-5 col-sm-6">
                    <hr class="section-heading-spacer">
                    <div class="clearfix"></div>
                    <h2 class="section-heading">Findip logs</h2>
                    <p class="lead">
' >> /opt/hackbox/report/web/findip.html

###Récupère la date###
echo "==============================<br>" >> /opt/hackbox/report/web/findip.html
echo "$(date) <br>" >> /opt/hackbox/report/web/findip.html

###Sniff to find Ip Class of LAN###
replay=1
i=0
while [ ${replay} -eq 1 ]
do
    prefixegarbage=$(tcpdump -l -n -c 1 -i eth0 ip | grep -Eo "[0-1][0-9]{2,3}\.[0-9]{1,3}\.[0-9]{1,3}\.")
    ipclean=${prefixegarbage//[$'\n']}
    prefixe_IP=$(echo "$ipclean" | cut -d'.' -f-3)
    prefixe_IP="$prefixe_IP."
    if [ ${i} -ge 5  ] || [ ${#prefixe_IP} -eq 1 ]; then echo -e "\033[31m\033[1mUnreachable address\033[0m" && echo "Unreachable address <br>" >> /opt/hackbox/report/web/findip.html && exit 1; fi
    echo " "
    echo -e "\033[32m\033[1m#####Lan discovery#####\033[0m"
    if [[ ${prefixe_IP:0:1} = "0" ]]
    then
        echo -e "\033[31m\033[1mActivité insuffisante sur le réseau\033[0m"
        echo "Activité insuffisante sur le réseau <br>" >> /opt/hackbox/report/web/findip.html
    else
        echo -e "\033[34m\033[1mPréfixe IP : \033[33m\033[1m$prefixe_IP\033[0m"
        echo "Préfixe IP : $prefixe_IP <br>" >> /opt/hackbox/report/web/findip.html
        replay=0
    fi
    let "i=$i + 1"
done

###Arping while IP is occupied###
num=1
rep=0
while [ ${rep} -eq 0 ]
do
    if [ ${num} -ge 254 ]
    then
        echo -e "\033[31m\033[1mAucune adresse IP disponible\033[0m"
        echo "Aucune adresse IP disponible <br>" >> /opt/hackbox/report/web/findip.html
        exit 1
    fi

    adresse=${prefixe_IP}${num}
    if arping -D -I eth0 -c 2 ${adresse} | grep -q "Received 0 response(s)"
    then
        echo -e "\033[33m\033[1m$adresse \033[0mest libre" && rep=1
    else
        echo -e "\033[33m\033[1m$adresse \033[0mest occupée"
    fi

    let "num=$num + 1"
done

ifconfig eth0 down
echo " "
echo -e "\033[32m\033[1m#####New Mac address for the Raspberry#####\033[0m"
macchanger -r eth0
ifconfig eth0 ${adresse} netmask 255.255.255.0
ifconfig eth0 up
echo " "
echo -e "\033[32m\033[1m#####Attribution de la nouvelle IP#####\033[0m"
echo -e "\033[34m\033[1mNEW IP : \033[31m\033[1m$adresse\033[0m"
echo -n "$adresse" > /opt/hackbox/report/ip.txt
echo "IP : $adresse <br>" >> /opt/hackbox/report/web/findip.html
echo "<br>" >> /opt/hackbox/report/web/findip.html
echo -e "\033[34m\033[1mLogs available in /opt/hackbox/report/web/findip.html\033[0m"
echo -e "\033[34m\033[1mIP address stocked in /opt/hackbox/report/ip.txt\033[0m"

displayIP=$(cat /opt/hackbox/report/ip.txt)
sed -i -e 's/<h3>.*<\/h3>/<h3>'${displayIP}'<\/h3>/g' /opt/hackbox/report/web/index.html

/usr/bin/xfce4-session-logout --logout
