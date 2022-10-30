#!/usr/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Script to install the apt packages required by Emiga or Amiberry. 
#
# Executed from: "emiga_setup.sh"
#
# @package: Emiga
# @author:  http://cwsoft.de
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Include required globals and helper functions if needed.
if [[ -z "$EMIGA_DIR" ]]; then 
   source "$HOME/Emiga/scripts/setup/helper.sh"
fi

header "Executing: 'install_apt_packages.sh'"

## Update APT package index
printf "~> Updating apt package index... "
sudo apt-get update > /dev/null 2>&1
status

## Install APT packages required by Emiga
printf "~> Emiga: 'bash, grep, sed, samba, samba-common-bin, 7z, unzip, whiptail, wmctrl'... "
sudo apt-get -y install bash grep sed samba samba-common-bin p7zip-full unzip whiptail wmctrl > /dev/null 2>&1
status

## Install apt packages required by Amiberry
printf "~> Amiberry: 'libsdl2, libsdl2-ttf, libsdl2-image, flac, mpg123, libmpeg2'... "
sudo apt-get -y install libsdl2-2.0-0 libsdl2-ttf-2.0-0 libsdl2-image-2.0-0 flac mpg123 libmpeg2-4 > /dev/null 2>&1
status
