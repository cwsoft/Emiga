#!/usr/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Helper functions to ease console output messages.
#
# Usage: source "helper.sh"
#
# @package: Emiga
# @author:  http://cwsoft.de
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Define global variables used in Emiga setup scripts.
# Note: Desktop dir is adapted at end of this script.
EMIGA_DIR="$HOME/Emiga"
DESKTOP_DIR="$HOME/Desktop"

#---------------------- HELPER ROUTINES BELOW --------------------------
exitScriptIfInvokedByRoot() {
   ## Don't proceed if script is called via root/sudo.
   if [[ `whoami` == "root" ]]; then
      echo "> Error: Can't execute script as root/sudo."
      echo "> Script execution stopped"
      printf "\nUsage: $0\n\n"
      exit -1
   fi
}

header() {
   # Output header with a surrounding border.
   # $1: Header text, $2: Border char (Default:#)
   # Use defaults if no parameters were defined.
   text=${1:-HEADER}
   border=${2:-#}

   echo
   printf "$border%.0s" {1..60}
   printf "\n$border $text\n"
   printf "$border%.0s" {1..60}
   echo
}

section() {
   # Output section header.
   echo
   echo "## SECTION: $1"
}

status() {
   # Check status of last command or from optional argument.
   # Example: check_status 0 [OK], check_status -1 [FAILED]

   # Capture exit code of last executed command.
   status=$?

   # ANSI codes to modify text color.
   clear='\033[0m'
   red='\033[1;31m'
   green='\033[1;32m'

   # Overwrite status with optional function parameter.
   if [[ $# -gt 0 ]]; then status="$1"; fi

   if [[ "$status" -eq 0 ]]; then
      echo -e "${green}[OK]${clear}";
   else
      echo -e "${red}[FAILED]${clear}";
      exit $status
   fi
}

setDesktopDir() {
   # Work out users desktop folder and store in $DESKTOP_DIR.
   # Depending on distro/local, the $HOME/Desktop folder may differ.  
   if [[ ! -d "$DESKTOP_DIR" ]]; then
      if [[ -f "$HOME/.config/user-dirs.dirs" ]]; then
         source "$HOME/.config/user-dirs.dirs"
         if [[ ! -z "$XDG_DESKTOP_DIR" ]]; then
            DESKTOP_DIR="$XDG_DESKTOP_DIR"
         fi
      fi
   fi
}

## Set $DESKTOP_DIR depending on Linux distribution or users local.
setDesktopDir
