#!/usr/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Emiga script to launch Amiberry with specified configuration.
# Config files stored in: "$HOME/Emiga/public/configs/*.uae"
#
# Usage: amiberry.sh [emiga.uae]
#
# @package: Emiga
# @author:  http://cwsoft.de
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Define optional Amiberry config file via $1 (Default: "emiga.uae").
uaeConfig=${1:-emiga.uae}

# Ensure user config stays in config folder and has extension ".uae".
uaeConfig="$HOME/Emiga/public/configs/$(basename "$uaeConfig" .uae).uae"

# Try to activate window of possible running Amiberry process.
wmctrl -l | grep -q Amiberry > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
   wmctrl -R Amiberry > /dev/null 2>&1
   exit 0
fi

# Start Amiberry with specified config file or default config and no GUI.
if [[ -f "$uaeConfig" ]]; then
   cd "$HOME/Emiga/amiberry"
   ./amiberry --config "$uaeConfig" -G
   exit 0
fi

# Amiberry config file does not exist, show warning and quit.
lxterminal --title "Amiberry Launcher" -e whiptail \
   --title "Amiberry Launcher" --msgbox \
   "Specified Amiberry config file does not exist: $uaeConfig" 10 60
exit -1
