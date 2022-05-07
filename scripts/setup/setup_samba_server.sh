#!/usr/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Script to setup samba server allowing the user to copy legal Amiga
# files (e.g. kickstart roms, games) or to tweak Amiberry config files
# from another computer via samba shares //emiga. 
#
# Executed from: "emiga_setup.sh"
#
# @package: Emiga
# @author:  http://cwsoft.de
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
header "Executing: 'setup_samba_server.sh'"

## Setup samba server
printf "~> Checking for smb.conf... "
if [[ -f /etc/samba/smb.conf ]]; then status 0; else status -1; fi 

## Check if [emiga] section already appended to smb.conf.
if ! grep -q "\[emiga\]" /etc/samba/smb.conf > /dev/null 2>&1; then
   printf "~> Adding [emiga] share to smb.conf... "
   cat $EMIGA_DIR/templates/samba/smb.conf.tpl | sudo tee -a /etc/samba/smb.conf > /dev/null 2>&1
   status
fi

## Replace {HOME} with home path of the actual user.
printf "~> Set pathes in [emiga] section... "
sudo sed -i "s#{HOME}#$HOME#g" /etc/samba/smb.conf > /dev/null 2>&1
status

## Ensure public folder exists and is accessible.
if [[ ! -d $EMIGA_DIR/public ]]; then status -1; fi
printf "~> Set permissions for '$EMIGA_DIR/public'... " 
chmod -R a+rwx $EMIGA_DIR/public > /dev/null 2>&1
status

## Start samba service.
printf "~> Restart smbd service... "
sudo systemctl restart smbd > /dev/null 2>&1
status
