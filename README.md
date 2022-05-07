# Emiga - Emulated Amiga for Pi4/400
This repo allows you to create an emulated Amiga environment (Emiga) on your Pi 4/400 on top of a clean [RPiOS-64 LXDE Desktop](https://www.raspberrypi.com/software/operating-systems/#raspberry-pi-os-64-bit) installation. The setup installs the required apt packages, [Amiberry v5.1 (SDL2)](https://github.com/midwan/amiberry), sets-up a Samba server (`\\emiga` for Windows users) and adds some desktop icons and a Amiga wallpaper to your RPiOS-64 LXDE Desktop.

![Screenshot](./assets/screenshots/emiga_env.png)

**Please note:** To stay legal, no copyright stuff like Amiga Kickstart roms, Workbench setups or games are included. It's up to you to make it work by adding the required Amiga kickstart roms for the Amiberry emulator and your custom Workbench setups (e.g. from [Cloanto](https://www.amigaforever.com) or [Hyperion](https://www.hyperion-entertainment.com)). Once Emiga is setup on your Pi, you can use the `ImportWizard` to import your Kickstart roms or your custom Emulations Setups like [AmiKit](https://www.amikit.amiga.sk) or [Pimiga](https://youtube.com/watch?v=KLJk8fTjQLw) from a USB drive. Details about the process are outlined in **Section D**.

## A: Prerequisites
- Pi4/400 with a fast SD-card (recommended size 32 GB or higher)
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
2. Grab a coffee and wait until the Emiga setup is finished
3. Reboot your Pi to apply any pending Emiga settings

## D: Customize your Emiga Setup
After the initial setup, you will find three icons on your Linux Desktop:
- **Amiberry**: Opens the [Amiberry v5.1 (SDL2)](https://github.com/midwan/amiberry) GUI (create or modify your own Amiga setup like Workbench 3.x)
- **StartManager**: Defines which setup will be launched after reboot (Default: LXDE Linux Desktop)
- **ImportWizard**: Imports your Kickstart Roms and Emulation Setups (e.g. Workbench 3.x, [AmiKit](https://www.amikit.amiga.sk), [Pimiga](https://youtube.com/watch?v=KLJk8fTjQLw))

To add your own setup, you could purchase [AmiKit](https://www.amikit.amiga.sk) or download [Pimiga](https://youtube.com/watch?v=KLJk8fTjQLw) and port those setups over to Emiga, or create your own Workbench setup containing your favorite tools and games. I use three customized setups (Amikit, Emiga, Pimiga) on a regular basis not included in the free Emiga base package due to active copyright. 

If you want to learn how to create or port your own Amiga emulation setups to Emiga, just check out one of the available [Youtube videos](https://www.youtube.com/watch?v=Jcv2twlDT3s) out there or contact me via my Github account. If you have Amikit for Pi or Pimiga installed already, the process is as simple as copying over some files to your USB stick and to adapt some pathes in the .uae config files. Depending on the previous screen modes, you may need to set a proper screen resolution (System:Prefs/ScreenMode) after the first start of your ported Amiga environment.

### Create your own Amiga Environment (e.g. Workbench)
1. Open Amiberry by clicking the *Amiberry* icon
2. [Create your own setup](https://www.youtube.com/watch?v=XKnSbTQDI_o) and store the Amiberry config file in `Emiga/public/configs/your_config.uae`. All folders, files and games of your setup should be stored in it's own subfolder like `Emiga/emulations/your_setup/`.
3. Copy `Emiga/templates/desktop/emulation.desktop.tpl` to `$HOME/Desktop/your_setup.desktop`
4. Adapt the `{PLACEHOLDERS}` for name, descriptions and pathes in `your_setup.desktop` to fit your needs.
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
5. Click on *StartManager* icon to select your preferred start mode (LXDE Desktop or any of your Amiberry config.uae).

### Prepare USB Stick for ImportWizard (OPTIONAL)
Once you've created your own custom emulation setup(s), copy it over on a USB stick to backup, recreate or share them with others. The *ImportWizard* expects a certain file structure for importing data to your Emiga setup as outlined below.
```
emiga/
  kickstarts/
    your_legal_kickstart.rom (basename.ext)
    another_legal_kickstart.rom (basename.ext)
    rom.key (basename.ext)
    ...
  emulations/
    setup1/ (folder name is up to you)
      setup1.zip (REQUIRED: Zip name must match folder name)
      setup1.uae (REQUIRED: Amiberry config must match folder name)
      setup1.png (OPTIONAL: If provided, a desktop icon will be created for you)
    setup2/ (another custum setup)
      setup2.zip (REQUIRED: Zip name must match folder name)
      setup2.uae (REQUIRED: Amiberry config must match folder name)
      setup2.png (OPTIONAL: If provided, a desktop icon will be created for you)
    ...
```

The `setup.zip` archive includes all required files (e.g. harddisks, harddrives, folders, files, apps, games) of your custom Amiga emulation setup. The `setup.uae` file provides the Amiberry configuration of your setup (e.g. Amiga Model, Hardware, Kickstarts, Harddrives). If you want to share your setup with others, you can use the placeholder `{HOME}` in your `setup.uae`, which resolves to the users `$HOME` path during the import process.

**PLEASE NOTE:** The `import_wizarad.sh` script scans for USB drives mounted to `/media/USER` for a `emiga` folder with the subfolders `kickstarts` and `emulations`. Each valid emulation setup must contain a `setup.zip` and `setup.uae` and stick to the naming conventions layed out above to be recognized. If you provide an optional `setup.png` file, a Desktop icon named `Setup` will be automatically created for you. Ensure your SD card has enough space left to copy/unzip your files, as the ImportWizard won't check available disk space for you. If you have files larger than 4 GB, remember to format the USB stick with a file system supporting large files like `exFat`.

## E: License
The bash setup scripts and templates are released under [GNU General Public License](./LICENSE.txt) (Version 3). If you base your work upon Emiga, please respect the chosen license for your customized version as well.

## F: Contribution
Any help or input is highly appreciated. If you would like to contribute to this project, just contact me via Github or send me a pull request to review and include your code proposals.

Have fun
cwsoft
