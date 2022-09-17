#!/usr/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Script to setup the free GNU GPL Amiberry Amiga Emulator from Midwan.
# Please consider a donation to Midwan to support his great project.
# Amiberry URL: https://github.com/midwan/amiberry.
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

## Global variables to define the Amiberry binary file to download.
GH_URL="https://github.com/BlitterStudio/amiberry/releases/download"
AMIBERRY_VERSION="v5.3"
AMIBERRY_BINARY="amiberry-$AMIBERRY_VERSION-rpi4-sdl2-64bit-debian.zip"
AMIBERRY_URL="$GH_URL/$AMIBERRY_VERSION/$AMIBERRY_BINARY"

header "Executing: 'setup_amiberry.sh'"

## Creating download folder if not exists.
if [[ ! -d $EMIGA_DIR/downloads ]]; then
   printf "~> Creating folder: '$EMIGA_DIR/downloads/'... "
   mkdir -p $EMIGA_DIR/downloads > /dev/null 2>&1
   status
fi

## Create public/configs folder if not exists.
if [[ ! -d $EMIGA_DIR/public/configs ]]; then
   printf "~> Creating folder: '$EMIGA_DIR/public/configs/'... "
   mkdir -p $EMIGA_DIR/public/configs > /dev/null 2>&1
   status
fi

## Create public/kickstarts folder if not exists.
if [[ ! -d $EMIGA_DIR/public/kickstarts ]]; then
   printf "~> Creating folder: '$EMIGA_DIR/public/kickstarts/'... "
   mkdir -p $EMIGA_DIR/public/kickstarts > /dev/null 2>&1
   status
fi

## Downloading amiberry binary for RPiOS-64-bit if not exists in download folder.
if [[ ! -f $EMIGA_DIR/downloads/$AMIBERRY_BINARY ]]; then
   printf "~> Downloading '$AMIBERRY_BINARY'... "
   curl -L --output $EMIGA_DIR/downloads/$AMIBERRY_BINARY "$AMIBERRY_URL" > /dev/null 2>&1
   status
fi

## Extract amiberry archive if no amiberry folder yet exists.
if [[ ! -d $EMIGA_DIR/amiberry ]]; then
   printf "~> Extracting '$AMIBERRY_BINARY' -> '$EMIGA_DIR/amiberry/'... "
   unzip -q "$EMIGA_DIR/downloads/$AMIBERRY_BINARY" -d "$EMIGA_DIR/amiberry" > /dev/null 2>&1
   status

   ## Check if Amiberry files and folders are contained in a subfolder.
   if [[ ! -f $EMIGA_DIR/amiberry/amiberry ]]; then
      printf "~> Adapt Amiberry folder structure... "
      mv $EMIGA_DIR/amiberry/*/* $EMIGA_DIR/amiberry/ > /dev/null 2>&1
      rm -r $EMIGA_DIR/amiberry/amiberry*/ > /dev/null 2>&1
      status
   fi

   ## Copy Amiberry AROS kickstart roms into public/kickstarts folder.
   printf "~> Copy Amiberry AROS kickstart roms to '$EMIGA_DIR/public/kickstarts/'... "
   cp $EMIGA_DIR/amiberry/kickstarts/aros* $EMIGA_DIR/public/kickstarts > /dev/null 2>&1
   status
fi

## Create symlink for Amiberry conf/ folder.
if [[ -d $EMIGA_DIR/amiberry/conf ]]; then
   printf "~> Create symlink: 'amiberry/conf/' -> '$EMIGA_DIR/public/configs/'... "
   mv $EMIGA_DIR/amiberry/conf $EMIGA_DIR/amiberry/conf.org > /dev/null 2>&1
   ln -fs $EMIGA_DIR/public/configs $EMIGA_DIR/amiberry/conf > /dev/null 2>&1
   status
fi

## Create symlink for Amiberry kickstarts/ folder.
if [[ -d $EMIGA_DIR/amiberry/kickstarts ]]; then
   printf "~> Create symlink: 'amiberry/kickstarts/' -> '$EMIGA_DIR/public/kickstarts/'... "
   mv $EMIGA_DIR/amiberry/kickstarts $EMIGA_DIR/amiberry/kickstarts.org > /dev/null 2>&1
   ln -fs $EMIGA_DIR/public/kickstarts $EMIGA_DIR/amiberry/kickstarts > /dev/null 2>&1
   status
fi

## Copy over Amiberry configuration templates.
for template in $EMIGA_DIR/templates/amiberry/*.tpl; do
   target=$(basename $template .tpl)
   printf "~> Copy '$target' -> '$EMIGA_DIR/public/configs/'... "
   cp $template $EMIGA_DIR/public/configs/$target > /dev/null 2>&1
   sed -i "s#{HOME}#$HOME#g" $EMIGA_DIR/public/configs/$target > /dev/null 2>&1
   status
done
