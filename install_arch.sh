#!/bin/bash

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que root."
  exit 1
fi

# Mise à jour des paquets et du système
sudo pacman -Syu --noconfirm

# Décommente les lignes dans pacman.conf (multilib)
sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf

# Mise à jour des dépôts après modification de pacman.conf
sudo pacman -Syu --noconfirm

# Installation des paquets nécessaires
sudo pacman -S --noconfirm xorg ldns firefox dhcpcd vim plasma-desktop xorg-xinit networkmanager iputils git picom feh base-devel make libx11 netctl libxinerama gnu-free-fonts noto-fonts ttf-jetbrains-mono xrandr konsole

# Démarrage et activation de dhcpcd
sudo systemctl start dhcpcd
sudo systemctl enable dhcpcd

# Ajout des serveurs DNS dans resolv.conf
echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" | sudo tee /etc/resolv.conf

# Installation de yay pour AUR
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..

# Ajout de configurations dans .bashrc ou .bash_profile
echo '[[ -f ~/.bashrc ]] && . ~/.bashrc' >> ~/.bash_profile
echo 'if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then' >> ~/.bash_profile
echo '  exec startx' >> ~/.bash_profile
echo 'fi' >> ~/.bash_profile

# Configuration de .xinitrc
echo 'xrandr --output "Virtual-1" --mode 1920x1080' > ~/.xinitrc
echo 'xrandr --output "Virtual1" --mode 1920x1080' > ~/.xinitrc
echo 'picom &' >> ~/.xinitrc
echo 'exec startplasma-x11' >> ~/.xinitrc

# Installation de mkinitcpio-numlock via yay
yay -S --noconfirm mkinitcpio-numlock

# Ajout de la configuration dans mkinitcpio.conf pour numlock
sudo sed -i '/^HOOKS=/s/keyboard/keyboard numlock/' /etc/mkinitcpio.conf

# Regénération de l'initramfs pour appliquer les changements
sudo mkinitcpio -P

# Redémarrage du système
echo "Installation terminée. Le système va redémarrer dans 10 secondes..."
sleep 10
sudo reboot
