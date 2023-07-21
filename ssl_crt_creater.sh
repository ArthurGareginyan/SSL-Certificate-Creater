
#!/bin/bash

#=============================================================#
# Name:         SSL Certificate Creater                       #
# Description:  Create a self-signed SSL Certificates         #
#               for Apache and Nginx web-servers.             #
# Version:      1.4                                           #
# Released:     25.05.2015                                    #
# Updated:      21.07.2023                                    #
# Author:       Arthur Gareginyan                             #
# Author URI:   http://www.arthurgareginyan.com               #
# Email:        arthurgareginyan@gmail.com                    #
# License:      MIT License                                   #
# License URI:  http://opensource.org/licenses/MIT            #
#=============================================================#

#                  USAGE:
#        chmod +x ./ssl_crt_creater.sh
#        sudo ./ssl_crt_creater.sh


################## DECLARE FUNCTIONS ######################

# Function to check if the script is run as root
checkRoot() {
    if [ $(id -u) -ne 0 ];
        then
            printf "Script must be run as root. Try 'sudo ./ssl_certificate_creater.sh'\n"
            exit 1
    fi
}

# Function to check if the necessary packages are installed and install them if necessary
checkNeededPackages() {
    # List of necessary packages
    lst="dialog openssl"
    
    # Loop over the list of packages
    for items in $lst
    do
        # If a package is not installed
        type -P $items &>/dev/null || {
            echo -en "\n Package \"$items\" is not installed!"
            echo -en "\n Install now? [yes]/[no]: "
            read ops
            case $ops in
                YES|yes|Y|y)
                    # If 'apt-get' is available, use it to install the package
                    if [ -n "$(command -v apt-get)" ]; then
                        apt-get install $items
                    # Else, if 'dnf' is available, use it to install the package
                    elif [ -n "$(command -v dnf)" ]; then
                        dnf install $items
                    # Else, if 'yum' is available, use it to install the package
                    elif [ -n "$(command -v yum)" ]; then
                        yum install $items
                    # Else, if 'zypper' is available, use it to install the package
                    elif [ -n "$(command -v zypper)" ]; then
                        zypper install $items
                    else
                        # If no known package manager is found, print an error message and exit the script
                        echo "No known package manager found"
                        exit 1
                    fi ;;
                *)
                    # If the user chooses not to install the necessary packages, print a message and exit the script
                    echo -e "\n Exiting..."
                    exit 1 ;;
            esac
        }
    done
}

# Function to get the server name from the user
setServerName() {
    # Display a dialog box and store the user's input in the 'choices' variable
    cmd=(dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
        --inputbox "\n Please enter the URL of your website." 22 76 $__servername)
    choices=$("${cmd[@]}" 2>&1 >/dev/tty)
    
    # If the user entered a server name, store it in the '__servername' variable
    if [ "$choices" != "" ];
        then
            __servername=$choices
        else
            break
    fi
}

# Function to get the certificate validity period from the user
setValidityPeriod() {
    # Display a dialog box and store the user's input in the 'choices' variable
    cmd=(dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
        --inputbox "\n Please enter the validity period of the certificate (in days)." 22 76 $validity_period)
    choices=$("${cmd[@]}" 2>&1 >/dev/tty)
    
    # If the user entered a validity period, store it in the 'validity_period' variable
    if [ "$choices" != "" ];
        then
            validity_period=$choices
        else
            break
    fi
}

# Function to check if the server name has been set
checkServerName() {
    if [ "$__servername" = "" ];
        then
            setServerName
    fi
}

# Function to check if the certificate validity period has been set
checkValidityPeriod() {
    if [ "$validity_period" = "" ];
        then
            setValidityPeriod
    fi
}

# Function to generate a certificate for a specific server type and certificate directory
generateCertificate() {
    # Store the function arguments in variables
    server_type=$1
    cert_dir=$2

    # Display a message to the user
    dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
           --title "Create SSL Certificate for $server_type" \
           --msgbox "\n We are now going to create a self-signed certificate. While you could simply press ENTER when you are asked for country name etc. or enter whatever you want, it might be beneficial to have the web servers host name in the common name field of the certificate." 20 60

    # Create the certificate directory if it doesn't exist
    mkdir -p $cert_dir

    # Generate the certificate and store it in the certificate directory
    openssl req -new -x509 -days $validity_period -nodes -out $cert_dir/$__servername.crt -keyout $cert_dir/$__servername.key

    # Change the permissions of the key file
    chmod 600 $cert_dir/$__servername.key

    # Display a message to the user
    dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
           --title "Create SSL Certificate for $server_type" \
           --msgbox "\n Done! Your certificates are available at $cert_dir/$__servername.crt & $cert_dir/$__servername.key" 20 60
}


######################## GO ###############################

# Check if the script is run as root
checkRoot

# Check if the necessary packages are installed
checkNeededPackages

# Main loop
while true;
do
    # Display a menu to the user
    cmd=(dialog --backtitle "mycyberuniverse.com - Create SSL Certificate for NGinX/Apache" \
                --title "Create SSL Certificate for NGinX/Apache" \
                --menu "You MUST set the server URL (e.g., myaddress.dyndns.org) and certificate validity period (in days) before starting create certificate. Choose task:" 20 60 15)
    options=(1 "Set server URL ($__servername)"
             2 "Set certificate validity period ($validity_period)"
             3 "Generate new SSL certificate for NGiNX"
             4 "Generate new SSL certificate for Apache"
             5 "Exit")
    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [ "$choice" != "" ];
        then
            case $choice in
                1) setServerName ;;
                2) setValidityPeriod ;;
                3) checkServerName
                   checkValidityPeriod
                   generateCertificate "NGinX" "/etc/nginx/ssl" ;;
                4) checkServerName
                   checkValidityPeriod
                   generateCertificate "Apache" "/etc/apache2/ssl" ;;
                5) clear
                   exit 0 ;;
            esac
        else
            break
    fi
done
clear

exit 0
