#!/usr/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Setup the Emiga Linux Desktop for the actual user.
# Copies Emiga desktop icons and wallpaper and setup Emiga autostart.
#
# Executed from: "emiga_setup.sh"
#
# @package: Emiga
# @author:  http://cwsoft.de
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
header "Executing: 'setup_linux_desktop.sh'"

## Check if $DESKTOP_DIR exists inside users home folder.
printf "~> Check for folder: '$DESKTOP_DIR'... "
if [[ -d "$DESKTOP_DIR" ]]; then status 0; else status -1; fi

## Disable cups-browsed service to avoid long shutdowns (90s).
if [[ -f /etc/cups/cups-browsed.conf ]]; then
   printf "~> Disable cups-browsed service for faster shutdown... "
   sudo systemctl disable cups-browsed.service > /dev/null 2>&1
   status
fi

## Change hostname to emiga.
printf "~> Set hostname to 'emiga'... "
sudo hostnamectl set-hostname emiga > /dev/null 2>&1
status

## Copy Emiga bash_aliases file if none exists.
if [[ ! -f $HOME/.bash_aliases ]]; then
   printf "~> Creating '$HOME/.bash_aliases'... "
   cp $EMIGA_DIR/templates/bash/bash_aliases.tpl $HOME/.bash_aliases > /dev/null 2>&1
   source $HOME/.bashrc > /dev/null 2>&1
   status
fi

## Create user autostart folder if not exists.
if [[ ! -d "$HOME/.config/autostart" ]]; then
   printf "~> Creating folder: '$HOME/.config/autostart/'... "
   mkdir -p "$HOME/.config/autostart" > /dev/null 2>&1
   status
fi

## Copy Emiga autostart files and replace {HOME} by home path.
for template in $HOME/Emiga/templates/autostart/*.desktop.tpl; do
   target=$(basename $template .tpl)
   printf "~> Copy '$target' -> '$HOME/.config/autostart/'... "
   cp $template $HOME/.config/autostart/$target > /dev/null 2>&1
   sed -i "s#{HOME}#$HOME#g" $HOME/.config/autostart/$target > /dev/null 2>&1
   status 0
done

## Copy Emiga desktop icons and replace {HOME} by home path.
for template in $HOME/Emiga/templates/desktop/*.desktop.tpl; do
   target=$(basename $template .tpl)
   if [[ $target != "emulation.desktop" ]]; then
      printf "~> Copy '$target' -> '$DESKTOP_DIR/'... "
      cp $template "$DESKTOP_DIR/$target" > /dev/null 2>&1
      sed -i "s#{HOME}#$HOME#g" $DESKTOP_DIR/$target > /dev/null 2>&1
      status 0
   fi
done

## Disable dialog when opening executable files in filemanager pcmanfm.
libfmConfig=$HOME/.config/libfm/libfm.conf
if [[ -f $libfmConfig ]] && grep -q "quick_exec=0" $libfmConfig; then
   printf "~> Killing actual pcmanfm process... "
   killall pcmanfm > /dev/null 2>&1
   status
   
   printf "~> Change pcmanfm settings to open executables w/o warning... "
   sed -i "s#quick_exec=0#quick_exec=1#g" $HOME/.config/libfm/libfm.conf > /dev/null 2>&1
   status

   printf "~> Restart pcmanfm process... "
   pcmanfm --desktop --profile=LXDE-pi --display=:0 > /dev/null 2>&1 &
   status
   sleep 2

   # Apply Emiga wallpaper when pcmanfm is used.
   if [[ -f $EMIGA_DIR/assets/wallpaper/emiga-wallpaper_1920x1080.png ]]; then
      printf "~> Applying Emiga wallpaper... "
      pcmanfm --set-wallpaper $EMIGA_DIR/assets/wallpaper/emiga-wallpaper_1920x1080.png > /dev/null 2>&1
      status
   fi
fi

## Set Emiga splash image shown on bootup and shutdown.
bootImage=/usr/share/plymouth/themes/pix/splash.png
if [[ -f $bootImage && ! -L $bootImage ]]; then
   printf "~> Applying Emiga splash image... "
   sudo mv $bootImage $bootImage.org > /dev/null 2>&1
   sudo ln -s $EMIGA_DIR/assets/splash/splash.png $bootImage > /dev/null 2>&1
   status
fi
