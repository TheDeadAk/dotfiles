#! /bin/bash
#iwctl --passphrase mowBefis9Bly station wlan0 connect AML

# Calc wifi strength
wifiStrength(){
    local str=$(awk 'NR==3 {print $3 "00"}''' /proc/net/wireless | cut -c -2 )
    echo "$str"
    
}
# Connect to wifi
connectWifi(){
    __nopass=1
    __pass="mowBefis9Bly"
    __network="AML"
    # Default yes/no
    read -p "Run default config? ( y/N )  " yesno
    case $yesno in
	[Yy]* )
	    eval "iwctl --passphrase $__pass station wlan0 connect $__network"
	    exit;;
    esac

    eval "iwctl station wlan0 get-networks"
    read -p "Choose network: " __network
    
    #Passphrase yes/no - set passphrase
    read -p "Password? ( Y/n )  " __pass
    case "$__pass" in
	[Nn]* )
		eval "iwctl station wlan0 connect $__network"
		exit;;
	[Yy]* )
		read -p "Write passphrase for $__network: " __pass
		eval "iwctl --passphrase $__pass station wlan0 connect $__network"
		exit;;
    	* )
		echo "Command not understood"
		exit;;
    esac

#    eval "iwctl station wlan0 get-networks"
#    read -p "Choose network: " __network
#    echo $__nopass
    #Network set network name 
#    if [[ $__nopass == 1 ]]; then
#	echo "1.1"
#      eval "iwctl station wlan0 connect $__network"
#    else
#	echo "1.2"
#      read -p "Write passwork for $__network: " __pass
#      eval "iwctl --passphrase $__pass station wlan0 connect $__network"
#    fi
#    echo 2
}

case "$1" in
    "--connect" | "-c")
        connectWifi
        exit;;
    "--wifiStrength" | "-ws")
        wifiStrength "${@:2}"
        exit;;	
esac
