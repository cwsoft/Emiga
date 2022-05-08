# Emiga - Emulated Amiga for Pi4/400
This repo allows you to create an emulated Amiga environment (Emiga) on your Pi 4/400 on top of a clean [RPiOS-64 LXDE Desktop](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit) installation. The setup installs the required apt packages, [Amiberry v5.1 (SDL2)](https://github.com/midwan/amiberry), sets-up a Samba server (`\\emiga` for Windows users) and adds some desktop icons and a Amiga wallpaper to your RPiOS-64 LXDE Desktop.

![Screenshot](./assets/screenshots/emiga_env.png)

**Please note:** To stay legal, no files under active copyright are contained in the default Emiga setup. It's up to you to setup your own Amiga Workbench or to port over any of your existing [AmiKit](https://www.amikit.amiga.sk) or [Pimiga](https://youtube.com/watch?v=KLJk8fTjQLw) setups to Emiga. The required steps are shown in
**Section D**.

## A: Prerequisites
- Pi4/400 with a fast SD-card (recommended 32 GB, to port Pimiga2 use 64 GB at least)
- Preinstalled [Raspberry Pi OS LXDE Desktop](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit) (64-bit, Debian Bullseye)

## B: Setup RPiOS-64 LXDE Desktop
1. Download latest official [RPiOS-64 LXDE Desktop image](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit)
2. Check SHA256 hash before flashing the image on your SD card to ensure integrity
3. Flash image to new/empty SD card (e.g. [Raspberry Pi Imager](https://www.raspberrypi.com/software/) or [balenaEtcher](https://www.balena.io/etcher/))
4. Boot your Pi from the SD card just created
5. Follow initial RPiOS-64 desktop setup:
   - Set country, language and timezone
   - Create a new user account (no space in name)
   - Setup WiFi (choose network, enter credentials)
   - Download system updates
   - Reboot your Pi

## C: Setup Emiga on your Pi4/400
1. Open a terminal and execute the following commands:
   ```
   cd
   git clone https://github.com/cwsoft/Emiga.git
   ./Emiga/scripts/setup/emiga_setup.sh
   ```
2. Reboot your Pi to apply any pending Emiga settings

## D: Customize your Emiga Setup
After the initial Emiga setup, you will find three icons on your Linux Desktop:
- **Amiberry**: Opens the [Amiberry v5.1 (SDL2)](https://github.com/midwan/amiberry) GUI to create/modify your Amiga setups
- **StartManager**: Defines the setup started after reboot (Default: LXDE Linux Desktop)
- **ImportWizard**: Imports your ROMs and custom setups from a USB stick (e.g. Workbench 3.x, [AmiKit](https://www.amikit.amiga.sk), [Pimiga](https://youtube.com/watch?v=KLJk8fTjQLw))

The sections below explain how to setup your own Workbench or to port over your existing [AmiKit](https://www.amikit.amiga.sk) or [Pimiga](https://youtube.com/watch?v=KLJk8fTjQLw) setups to Emiga.

### D1: Create your own Workbench Setup
To start off, you need some legal Amiga kickstart roms and workbench files. Those files are contained for example in [Amiga Forever](https://www.amigaforever.com) from Cloanto or in [AmigaOS 3.2.x](https://www.hyperion-entertainment.com) from Hyperion. With those files, you can setup your own customized Amiga Workbench with all your favorite tools and games you enjoyed about 30 years back in time. It's assumed you know how to setup your own Workbench. If your knowledge is a bit rusty, you may want to check out some [HowTo guides](https://www.youtube.com/watch?v=jJG8-KG9tLI) on Youtube first.

**Steps to create your own Workbench Setup:**
1. Open Amiberry by clicking the *Amiberry* icon
2. [Create your own setup](https://www.youtube.com/watch?v=XKnSbTQDI_o) and store the Amiberry config file in `Emiga/public/configs/your_setup.uae`. All folders, files and games of your setup should be stored in a common subfolder like `Emiga/emulations/your_setup/`.
3. Copy `Emiga/templates/desktop/emulation.desktop.tpl` to `$HOME/Desktop/your_setup.desktop`
4. *Optional:* Copy a nice PNG Desktop icon for your setup to `$HOME/Emiga/assets/icons/your_setup.png`.
5. Adapt the `{PLACEHOLDERS}` for name, descriptions and pathes in `your_setup.desktop` to fit your needs.
```
[Desktop Entry]
Name={EMULATION_NAME} -> e.g. AmiKit
Comment=Start {EMULATION_NAME} 
GenericName=Started {EMULATION_NAME}

Type=Application
StartupNotify=false
Terminal=false
Exec={HOME}/Emiga/scripts/amiberry.sh {EMULATION_UAE} -> e.g. amikit.uae
Path={HOME}/Emiga/amiberry -> e.g. /home/USER
Icon={HOME}/Emiga/assets/icons/{EMULATION_PNG} -> e.g. amikit.png
```
6. Click on *StartManager* to select preferred start mode (LXDE Desktop or any of your custom Amiberry .uae configs).
7. Click on the Desktop icon of your setup added in Step 4 to start your setup.

**Please note:** When starting your own or ported Amiga setup the very first time, you most likely need to adapt the screen mode to have a nice user experience. On a Pimiga2 setup, the screen mode can be set via `System:Prefs/ScreenMode`. All Workbench setups should provide a tool called `ScreenMode` to choose a proper resultion like 32-bit 1080x1020 px.

### D2: Porting Pimiga2 to Emiga
**Note:** It's assumed you already have [Pimiga2](https://youtube.com/watch?v=KLJk8fTjQLw) up and running on your Pi4/400 including a stable internet connection.

1. Format a fast 64-GB USB 3.2 stick with `exFat` on your computer (e.g. Windows)
2. Stick the formated USB stick into your Pi, then boot up your Pimiga2 setup from SD-Card
3. Quit out of Pimiga Scalos Workbench via `(F12 -> Quit)`
4. Ensure the formated USB stick was mounted correctly during boot up. Enter `ls /media` and check for the mount-points: `usb` and `kick`.
5. Enter following commands to port Pimiga2 to your USB stick:
   ```
   # Install zip command (requires LAN/WLAN internet connection)
   sudo apt install zip
   
   # Create Emiga folder structure on USB drive and copy over kickstart roms and config files
   sudo mkdir -p /media/usb/emiga/kickstarts /media/usb/emiga/emulations/pimiga
   sudo cp /media/kick/*.* /media/usb/emiga/kickstarts
   sudo cp ~/amiberry/conf/Pimiga.uae /media/usb/emiga/emulations/pimiga/pimiga.uae
   sudo sed -i "s#/media/kick/#{HOME}/Emiga/public/kickstarts/#" /media/usb/emiga/emulations/pimiga/pimiga.uae
   sudo sed -i "s#/home/pi/#{HOME}/Emiga/emulations/#" /media/usb/emiga/emulations/pimiga/pimiga.uae
   
   # Create archive with all folders/files from ~/pimiga (~ 35 GB)
   # Note: This takes quite some time (about 1-2 hours) so go out for a nice walk
   cd
   sudo zip -r /media/usb/emiga/emulations/pimiga/pimiga.zip pimiga/*
   ```
6. Shutdown your Pi via `sudo shutdown now`, eject Pimiga SD-Card and plug in Emiga SD-Card, then reboot
7. Grab a nice Pimiga PNG icon from the WWW (e.g. PI-Symbol) and copy it to the USB stick created in Step 5 to `emiga/emulations/pimiga/pimiga.png`
8. Execute Emigas `ImportWizard` and import Pimiga2 from the prepared USB stick
9. Click on the Pimiga Desktop icon to start Pimiga (set proper ScreenMode on first boot via `System:Prefs\ScreenMode`).

### D3: Setup USB Stick for the ImportWizard
As outlined in **Section D2**, porting over any existing Amiga setup to Emiga is just a matter of copying some folders and files to an empty USB stick and to adapt some pathes in the WinUAE/Amiberry configuration files. The Emiga *ImportWizard* expects the a certain file structure on your USB stick in order to recognize your setup as outlined below:
```
emiga/
  kickstarts/
    your_legal_kickstart.rom (basename.ext)
    another_legal_kickstart.rom (basename.ext)
    rom.key (basename.ext)
    ...
  emulations/
    setup1/ (folder name is up to you)
      setup1.zip (REQUIRED: Zip file must match folder name)
      setup1.uae (REQUIRED: Config file must match folder name)
      setup1.png (OPTIONAL: Creates a desktop icon. Image file must match folder name)
    setup2/ (another custum setup)
      setup2.zip (REQUIRED: Zip file must match folder name)
      setup2.uae (REQUIRED: Config file must match folder name)
      setup2.png (OPTIONAL: Creates a desktop icon. Image file must match folder name)
    ...
```

**Note:** The `setup.zip` includes all required files (e.g. harddisks, harddrives, folders, files, apps, games) of your custom Amiga emulation setup. The `setup.uae` file provides the WinUAE/Amiberry configuration of your setup (e.g. Amiga Model, Hardware, Kickstarts, Harddrives). If you want to share your setup with others, you can use the placeholder `{HOME}` in your `setup.uae`, which resolves to the users `$HOME` path during the import process.

The `import_wizarad.sh` scans the USB drives mounted to `/media/USER` for a `emiga\kickstarts` and `emiga\emulations` folder. Each valid emulation setup must contain a `setup.zip` and `setup.uae` and stick to the naming conventions shown above to be recognized. If you provide an optional `setup.png` file, a Desktop icon named `Setup` will be automatically created for you. Ensure your SD card has enough space left to copy/unzip your files, as the ImportWizard won't check available disk space for you. If you have files larger than 4 GB, remember to format the USB stick with a file system supporting large files like `exFat`.

## E: License
The bash setup scripts and templates are released under [GNU General Public License](./LICENSE.txt) (Version 3). If you base your work upon Emiga, please respect the chosen license for your customized version as well.

## F: Contribution
Any help or input is highly appreciated. If you would like to contribute to this project, just contact me via Github or send me a pull request to review and include your code proposals.

Have fun
cwsoft
