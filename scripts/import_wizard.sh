#!/usr/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# The import wizard allows to import optional Amiga kickstart roms, or 
# custom Amiga emulation setups (e.g. Workbench 3.x) from a USB drive. 
#
# Executed from: "~/Desktop/import_wizard.desktop".
#
# @package: Emiga
# @author:  http://cwsoft.de
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Include required globals and helper functions.
source "$HOME/Emiga/scripts/setup/helper.sh"

# Ignore null values in globing (e.g. /*).
shopt -s nullglob

# Set scan dir to users media mount path.
SCAN_DIR="/media/`whoami`"

# Set bash window title using escape sequences.
title="Emiga Import Wizard"
echo -e '\033]2;'$title'\007'

########################################################################
## STEP 1: Ask user to plug in USB drive with data to import.
########################################################################
whiptail --title "Import Wizard - Insert valid USB Drive" \
   --msgbox "Please plug in USB drive with your Emiga files to import.\n"`
   `"Press 'OK' to start data import or 'ESC' to cancel." \
   10 78

if [[ $? -ne 0 ]]; then exit 0; fi 

########################################################################
## STEP 2: Check for a mounted drive containing proper file structure.
########################################################################
sourceDir=""
for scanDir in "$SCAN_DIR"/*; do
   if [[ -d $scanDir/emiga/kickstarts && -d $scanDir/emiga/emulations ]]; then
      sourceDir="$scanDir/emiga"
      break
   fi
done

if [[ -z "$sourceDir" ]]; then
   whiptail --title "Import Wizard - No valid USB drive found" \
      --msgbox "No USB drive with 'emiga' folder found in '$SCAN_DIR/*'.\n"`
      `"Insert USB stick with valid Emiga file structure and try again.\n\n"`
      `"Import Wizard will be terminated now." \
      10 78
   exit -1
fi

########################################################################
## STEP 3: Create list of files to import or extract.
########################################################################
kickstarts=("$sourceDir/kickstarts"/*.*)
nbrKickstarts=${#kickstarts[@]}

emulations=()
for emulation in "$sourceDir/emulations"/*; do
   if [[ -d $emulation ]]; then
      folderName=$(basename $emulation)
      
      # Valid emulation require a "folderName.zip" and "folderName.uae".
      if [[ -f "$emulation/$folderName.zip" && -f "$emulation/$folderName.uae" ]]; then
         emulations+=("$emulation")
      fi
   fi
done
nbrEmulations=${#emulations[@]}

nbrTotal=$(expr $nbrKickstarts + $nbrEmulations)
if [[ $nbrTotal -eq 0 ]]; then
   whiptail --title "Import Wizard - No import files found" \
      --msgbox "Path '$sourceDir' contains no import files. Import canceled." \
      10 78
   exit -1
fi

## Show overview of user provided files to be imported.
text=("Source path: $sourceDir\n")
text+="\nKickstart rom files found: $nbrKickstarts\n"
for path in ${kickstarts[@]}; do
   text+=" - $(basename $path)\n"
done

text+="\nValid emulation setups found: $nbrEmulations\n"
for path in ${emulations[@]}; do
   text+=" - $(basename $path)\n"
done

## Let user decide to import files or to cancel the dialog.
whiptail --title "Import Wizard - Overview of files to import" \
   --yesno --scrolltext "$text" \
   --yes-button "Import" --no-button "Cancel" --defaultno \
   25 78

if [[ $? -ne 0 ]]; then exit 0; fi 

########################################################################
## STEP 4: Copy over files to right Emiga spots.
########################################################################
clear
header "Import Wizard: Import user Emiga files from USB drive"

## Copy kickstart rom files.
if [[ ! -d $HOME/Emiga/public/kickstarts ]]; then
   mkdir -p $HOME/Emiga/public/kickstarts > /dev/null 2>&1
fi

section "Copy Kickstart Rom Files"
for file in ${kickstarts[@]}; do
   printf "~> Copy '$(basename $file)' -> $HOME/Emiga/public/kickstarts... "
   cp $file $HOME/Emiga/public/kickstarts > /dev/null 2>&1
   status
done

## Extracting emulation setups.
for file in ${emulations[@]}; do
   # Create emulation folder if not already exists.
   folderName=$(basename $file)
   section "Extracting Custom Emulation Setup '${folderName^}'"

   if [[ -d $HOME/Emiga/emulations/$folderName ]]; then
      mkdir -p $HOME/Emiga/emulations/$folderName > /dev/null 2>&1
   fi

   # Extract mandatory emulation zip file.
   echo "~> Extracting '$folderName.zip' -> $HOME/Emiga/emulations... "
   # Extract emulation archive (-aos:skip existings files, -bso0: minimal progress)
   7za x -aos -bso0 "$file/$folderName.zip" -o"$HOME/Emiga/emulations"
   extraction=$?

   # Delete previous command line output and show extraction status.
   printf '\e[A\e[K'
   printf "~> Extracting '$folderName.zip' -> $HOME/Emiga/emulations... "
   print_status $extraction

   # Show message on error and quit import.
   if [[ "$extraction" -ne 0 ]]; then
      echo "~> Extraction of '$folderName.zip' failed ... quitting import in 5s."
      sleep 5
      exit
   fi

   # Copy mandatory emulation config file and replace optional HOME placeholder.
   printf "~> Copy '$folderName.uae' -> $HOME/Emiga/public/configs... "
   cp $file/$folderName.uae $HOME/Emiga/public/configs > /dev/null 2>&1
   sed -i "s#{HOME}#$HOME#g" $HOME/Emiga/public/configs/$folderName.uae > /dev/null 2>&1
   status
   
   # Copy optional emulation icon file if exists and create a desktop icon.
   if [[ -f $file/$folderName.png ]]; then
      # Create icon folder if not exists.
      if [[ -d $HOME/Emiga/assets/icons ]]; then 
         mkdir -p $HOME/Emiga/assets/icons; 
      fi
      
      # Copy optional emulation icon.
      printf "~> Creating desktop icon for '${folderName^}'... "
      cp $file/$folderName.png $HOME/Emiga/assets/icons
      
      # Create desktop file for actual emulation and replace placeholders.
      cp $HOME/Emiga/templates/desktop/emulation.desktop.tpl /tmp
      sed -i "s#{HOME}#$HOME#g" /tmp/emulation.desktop.tpl > /dev/null 2>&1
      sed -i "s#{EMULATION_NAME}#${folderName^}#g" /tmp/emulation.desktop.tpl > /dev/null 2>&1
      sed -i "s#{EMULATION_UAE}#$folderName.uae#g" /tmp/emulation.desktop.tpl > /dev/null 2>&1
      sed -i "s#{EMULATION_PNG}#$folderName.png#g" /tmp/emulation.desktop.tpl > /dev/null 2>&1
      mv /tmp/emulation.desktop.tpl $DESKTOP_DIR/$folderName.desktop
      status
   fi
done

## Show status message if import was sucessfull.
whiptail --title "Import Wizard - Completed" \
   --msgbox "Data import finished. Time to enjoy your customized Emiga setup." \
   8 78
