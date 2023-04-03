<img src="https://github.com/vinceliuice/matcha/blob/imgs/logo.png" alt="Logo" align="right" /> Matcha Gtk Theme
======

Matcha is a flat Design theme for GTK 3, GTK 2 and Gnome-Shell which supports GTK 3 and GTK 2 based desktop environments like Gnome, Unity, Budgie, Pantheon, XFCE, Mate, etc.

This theme is based on Arc gtk theme of horst3180. Thanks horst3180 sincerely for his great job!

horst3180 - Arc gtk theme: https://github.com/horst3180/Arc-theme

## Donate

If you like my project, you can buy me a coffee:

<span class="paypal"><a href="https://www.paypal.me/vinceliuice" title="Donate to this project using Paypal"><img src="https://www.paypalobjects.com/webstatic/mktg/Logo/pp-logo-100px.png" alt="PayPal donate button" /></a></span>

## Info

### GTK+ > 3.20

### GTK2 engines requirment
- GTK2 engine Murrine 0.98.1.1 or later.
- GTK2 pixbuf engine or the gtk(2)-engines package.

Fedora/RedHat distros:

    yum install gtk-murrine-engine gtk2-engines

Ubuntu/Mint/Debian distros:

    sudo apt-get install gtk2-engines-murrine gtk2-engines-pixbuf

ArchLinux:

    pacman -S gtk-engine-murrine gtk-engines

Solus:

    sudo eopkg it gtk2-engine-murrine gtk-engines

Other:
Search for the engines in your distributions repository or install the engines from source.

## Install

### Install from source file

Double-click to open that script file,
Or open the terminal at current directory.

Run

    ./install.sh

Usage: ./install.sh [OPTIONS...]

OPTIONS:

```sh
  -d, --dest DIR           Specify theme destination directory (Default: /home/fedora/.themes)
  -n, --name NAME          Specify theme name (Default: Matcha)
  -c, --color VARIANTS     Specify theme color variant(s) [standard|dark] (Default: All variants)
  -t, --theme VARIANTS     Specify hue theme variant(s) [aliz|azul|sea|pueril] (Default: All variants)
  -s, --gnome-shell        Set gnome-shell flavor, where new is version 44.0 or later, [38|40|42|44] (Default: Auto detect)
  -l, --libadwaita         Force all libadwaita app use linked gtk-4.0 theme
  -g, --gdm                Install GDM theme, this option need root user authority! please run this with sudo
  -r, --remove             Remove(Uninstall) themes/GDM/libadwaita
  -h, --help               Show this help
```

### Fix for flatpak apps

    sudo flatpak override --filesystem=~/.themes

If you installed your theme in system theme folder then run:

    sudo flatpak override --filesystem=/usr/share/themes

### Install from flathub

    flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub org.gtk.Gtk3theme.Matcha-sea

### Install from repository

Archlinux:
This package is available in the AUR

    yay -S matcha-gtk-theme

FreeBSD:

    # pkg install matcha-gtk-themes

Solus:

    sudo eopkg it matcha-gtk-theme

## Icon theme for Matcha

- Qogir-manjaro:  https://github.com/vinceliuice/Qogir-icon-theme

## Screenshots

![01](https://github.com/vinceliuice/matcha/blob/imgs/screenshot01.png?raw=true)
![02](https://github.com/vinceliuice/matcha/blob/imgs/screenshot02.png?raw=true)
![03](https://github.com/vinceliuice/matcha/blob/imgs/screenshot03.png?raw=true)
![04](https://github.com/vinceliuice/matcha/blob/imgs/screenshot04.png?raw=true)
