#!/usr/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Startup manager allows to set preferred start mode like LXDE desktop 
# or any Amiberry config file located in $HOME/Emiga/public/configs/.
# Selected start mode stored in: "~/.config/autostart/startup.cfg". 
#
# Executed from: "~/Desktop/startup.desktop".
#
# @package: Emiga
# @author:  http://cwsoft.de
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Ignore null values in globing (e.g. /*).
shopt -s nullglob

# Set bash window title using escape sequences.
title="Emiga Startup Manager"
echo -e '\033]2;'$title'\007'

# Read user defined startup mode from config if exists (default:LXDE).
startupMode="LXDE"
startupConfig="$HOME/.config/autostart/startup.cfg"
if [[ -f "$startupConfig" ]]; then
   read -r startupMode < "$startupConfig" > /dev/null 2>&1
fi

# Create whiptail radiolist template as bash array.
nbrListItems=1
template=(
   --title "Emiga Startup Manager"
   --radiolist "Select preferred startup mode:" 
   20 78 $nbrListItems
   "LXDE" "Startup Linux LXDE Desktop" "ON"
)

# Add Amiberry configs located in $HOME/Emiga/public/ to whiptail template.
uaeConfigFileSelected=0
for uaeConfig in $HOME/Emiga/public/configs/*.uae; do
   # Extract display name and basename from actual uaeConfig.
   uaeDisplayName=$(basename "$uaeConfig" .uae)
   uaeConfigFile="$uaeDisplayName.uae"
   
   # Check if actual uaeConfig matches startup mode.
   selected="OFF"
   if [[ "$startupMode" == "$uaeConfigFile" ]]; then 
      selected="ON"
      uaeConfigFileSelected=1
   fi
   
   # Add Amiberry config as new radiolist item to whiptail template.
   template+=("${uaeDisplayName}" "Startup Amiberry [$uaeConfigFile]" "$selected")  
   let nbrListItems="nbrListItems=nbrListItems+1"
done

# Quit if no user provided Amiberry config file yet exists.
if [[ $nbrListItems == 1 ]]; then
   whiptail --msgbox --title "Emiga Startup Manager" \
   "No Amiberry config (.uae) found in '$HOME/Emiga/public/configs/'."` \
   `"\nBooting into Linux LXDE Desktop on next startup." 8 78
   exit 0
fi

# Adapt radiolist item count to reflect optional available Amiberry configs.
declare template[6]=$nbrListItems

# Unselect LXDE desktop if a valid uaeConfig was set as startup mode.
if [[ $uaeConfigFileSelected -eq 1 ]]; then declare template[9]="OFF"; fi

# Show radiolist dialog with available startup options and store selection.
selectedItem=$(whiptail "${template[@]}" 3>&1 1>&2 2>&3)

# Quit if user canceled out of the whiptail dialog.
if [[ -z "$selectedItem" ]]; then exit 0; fi

# Write selected startup mode to startup config file.
if [[ "$selectedItem" != "LXDE" ]]; then selectedItem="$selectedItem.uae"; fi
echo "$selectedItem" > "$startupConfig"

# Show status message.
whiptail --msgbox --title "Selected Startup Option" \
   "Launching into '$selectedItem' from next startup." 8 78
