#!/usr/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Script to setup Emiga environment on a clean Raspberry PiOS-64. 
# Installs required APT dependencies for Emiga and Amiberry and
# setup the Linux environment of the actual user to use Emiga. 
#
# Usage: emiga_setup.sh
#
# @package: Emiga
# @author:  http://cwsoft.de
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Define some globals.
EMIGA_DIR="$HOME/Emiga"
DESKTOP_DIR="$HOME/Desktop"

## Include helper functions.
source "$EMIGA_DIR/scripts/setup/helper.sh"

## Don't proceed if script is called as root/sudo.
exitScriptIfInvokedByRoot

## Set $DESKTOP_DIR depending on Linux distribution or users local.
setDesktopDir

## Main script starts here.
clear
header "Emiga main setup script (v0.5.0)" "="
echo "Executing Emiga main setup script. Time for some coffee."

## Install required apt packages.
source "$EMIGA_DIR/scripts/setup/install_apt_packages.sh"

## Install and setup Amiberry.
source "$EMIGA_DIR/scripts/setup/setup_amiberry.sh"

## Setup samba server.
source "$EMIGA_DIR/scripts/setup/setup_samba_server.sh"

## Configure linux desktop.
source "$EMIGA_DIR/scripts/setup/setup_linux_desktop.sh"

## Output status message.
printf "\nEmiga setup script finished.\n"

## Prompt user to reboot system now.
read -r -p "Reboot now to apply changes [Y/n]? " input > /dev/null

case "$input" in
   [nN][oO]|[nN])
      exit 0
      ;;
   *)
      printf "\nNote: First reboot may take up to 90s.\n"
      printf "Rebooting in 5s from now."
      sleep 5
      sudo reboot
      ;;
esac
