#! /usr/bin/env bash
notify-send "Matcha Theme" "Getting the latest version of the Matcha theme..." -i system-software-update
cd /tmp/; rm -Rf /tmp/matcha.zip 2>/dev/null
rm -Rf /tmp/Matcha-gtk-theme-master/ 2>/dev/null
wget https://github.com/vinceliuice/Matcha-gtk-theme/archive/master.zip -O matcha.zip
unzip matcha.zip; cd Matcha-gtk-theme-master
./install.sh
notify-send "All done!" "Enjoy the latest version of Matcha!" -i face-smile
