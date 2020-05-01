#!/bin/bash
#=============================================================#
# Name:         SSL Certificate Creater                       #
# Description:  Create a self-signed SSL Certificates         #
#               for Apache and Nginx web-servers.             #
# Version:      1.2                                           #
# Released:     25.05.2015                                    #
# Updated:      1.05.2020                                     #
# Author:       Arthur Gareginyan                             #
# Author URI:   http://www.arthurgareginyan.com               #
# Email:        arthurgareginyan@gmail.com                    #
# License:      MIT License                                   #
# License URI:  http://opensource.org/licenses/MIT            #
#=============================================================#

#                   USAGE:
#      chmod +x ./ssl_crt_creater.sh
#      sudo ./ssl_crt_creater.sh


################## DECLARE FUNCTIONS ######################

checkRoot() {
   if [ $(id -u) -ne 0 ]; then
     printf "Script must be run as root. Try 'sudo ./ssl_certificate_creater.sh'\n"
     exit 1
   fi
}

checkNeededPackages() {
   lst="dialog openssl"
   for items in $lst
   do
     type -P $items &>/dev/null || {
       echo -en "\n Package \"$items\" is not installed!"
       echo -en "\n Install now? [yes]/[no]: "
       read ops
       case $ops in
           YES|yes|Y|y) sudo apt-get install $items ;;
           	     *)  echo -e "\n Exiting..."
               		 exit 1 ;;
       esac
     }
   done
}

setServerName() {
    cmd=(dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
		--inputbox "\n Please enter the URL of your website." 22 76 $__servername)
    choices=$("${cmd[@]}" 2>&1 >/dev/tty)
    if [ "$choices" != "" ]; then
        __servername=$choices
    else
        break
    fi
}

checkServerName() {
   if [ "$__servername" = "" ]; then
         setServerName
   fi
}

installCertificateNginx() {
  dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
         --title "Create SSL Certificate for NGinX" \
	 --msgbox "\n We are now going to create a self-signed certificate. While you could simply press ENTER when you are asked for country name etc. or enter whatever you want, it might be beneficial to have the web servers host name in the common name field of the certificate." 20 60
  mkdir -p /etc/nginx/ssl
  openssl req -new -x509 -days 365 -nodes -out /etc/nginx/ssl/$__servername.crt -keyout /etc/nginx/ssl/$__servername.key
  chmod 600 /etc/nginx/ssl/$__servername.key
  dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
         --title "Create SSL Certificate for NGinX" \
         --msgbox "\n Done! Your certificates are available at /etc/nginx/ssl/$__servername.crt & /etc/nginx/ssl/$__servername.key" 20 60
}

installCertificateApache() {
  dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
         --title "Create SSL Certificate for Apache" \
	 --msgbox "\n We are now going to create a self-signed certificate. While you could simply press ENTER when you are asked for country name etc. or enter whatever you want, it might be beneficial to have the web servers host name in the common name field of the certificate." 20 60
  clear
  mkdir -p /etc/apache2/ssl
  openssl req -new -x509 -days 365 -nodes -out /etc/apache2/ssl/$__servername.crt -keyout /etc/apache2/ssl/$__servername.key
  chmod 600 /etc/apache2/ssl/$__servername.key
  dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
         --title "Create SSL Certificate for Apache" \
         --msgbox "\n Done! Your certificates are available at /etc/apache2/ssl/$__servername.crt & /etc/apache2/ssl/$__servername.key" 20 60
}


######################## GO ###############################

checkRoot
checkNeededPackages

while true; do
    cmd=(dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
                --title "Create SSL Certificate for NGinX/Apache" \
                --menu "You MUST set the server URL (e.g., myaddress.dyndns.org) before starting create certificate. Choose task:" 20 60 15)
    options=(1 "Set server URL ($__servername)"
             2 "Generate new SSL certificate for NGiNX"
             3 "Generate new SSL certificate for Apache"
             4 "Exit")
    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [ "$choice" != "" ]; then
        case $choice in
            1) setServerName ;;
            2) checkServerName
               installCertificateNginx ;;
            3) checkServerName
               installCertificateApache ;;
            4) clear
               exit 0 ;;
        esac
    else
        break
    fi
done
clear

exit 0
