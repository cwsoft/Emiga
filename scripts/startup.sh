#!/usr/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Script to startup into LXDE desktop or a defined Amiberry config.
# Startup mode stored in: "~/.config/autostart/startup.cfg".
# Config files searched in: "$HOME/Emiga/public/configs/*.uae"
#
# Executed from: "~/.config/autostart/startup.desktop".
#
# @package: Emiga
# @author:  http://cwsoft.de
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Path to file containing user defined startup mode.
startupConfig="$HOME/.config/autostart/startup.cfg"

# Startup into Linux LXDE desktop if no startup config file exists.
if [[ ! -f "$startupConfig" ]]; then exit 0; fi

# Read first line of startup config into uaeConfig.
read -r uaeConfig < "$startupConfig" > /dev/null 2>&1

# Ensure user config is read from config folder and has right extension.
uaeConfig="$HOME/Emiga/public/configs/$(basename "$uaeConfig" .uae).uae"

# Startup Amiberry without GUI if specified config file exists. 
if [[ -f "$uaeConfig" ]]; then
   cd "$HOME/Emiga/amiberry"
   ./amiberry --config "$uaeConfig" -G
fi
