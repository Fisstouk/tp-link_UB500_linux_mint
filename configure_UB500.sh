#!/bin/bash

set -x
set -e

if [ "$USER" != "root" ];
then
	echo "Please use this script as root"
	echo "This script will stop..."
	sleep 2
	exit
fi

if [ ! -f "/usr/bin/mokutil" ];
then
	echo "mokutil package will be installed..."
	sleep 2
	sudo apt install mokutil
	echo "Package installed"
fi

secureboot_test="mokutil --sb-state"


if [ $(secureboot_test) = "SecureBoot disabled" ] ;
then
	echo "Script will run..."
else
	echo "It is recommended to disable SecureBoot. Do you want to continue?"
	read answer	
	if [[ "$answer" = "n" || "$answer" = "no" || "$answer" = "No" ]] ;
	then
		exit 0
	fi	


sudo apt install git dkms mokutil
cd /home/$USER
git clone https://github.com/jeremyb31/bluetooth-5.15.git
cd bluetooth-5.15
make
sudo mv /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btusb.ko /lib/modules/$(uname -r)/kernel/drivers/bluetooth/btusb.ko.bak
sudo cp btusb.ko /lib/modules/$(uname -r)/kernel/drivers/bluetooth/
sudo depmod -a

# Install firmware rtl8761bu_config.bin and rtl8761bu_fw.bin
cd /lib/firmware/rtl_bt
sudo wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/rtl_bt/rtl8761bu_config.bin
sudo wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/rtl_bt/rtl8761bu_fw.bin
