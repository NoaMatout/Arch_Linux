#!/bin/bash

# Installation des dépendances
cd ~
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/dmenu
git clone https://git.suckless.org/st
mkdir suckless
mv dwm dmenu st suckless/

# Installation de DWM
cd suckless/dwm
sudo make clean install

# Installation de ST
cd ..
cd st
sudo make clean install

# Installation de DMENU
cd ..
cd dmenu
sudo make clean install

# Ajout de dwm au démarrage
cd ~
sed -i 's/^exec startplasma-x11/#exec startplasma-x11/' .xinitrc
echo "exec dwm" >> .xinitrc

# Patching de DWM
cd ~
cd suckless/dwm
mkdir patches
cd patches
curl -o attachbelow.diff https://dwm.suckless.org/patches/attachbelow/dwm-attachbelow-6.2.diff
curl -o alwayscenter.diff https://dwm.suckless.org/patches/alwayscenter/dwm-alwayscenter-20200625-f04cac6.diff
curl -o uselessgap.diff https://dwm.suckless.org/patches/uselessgap/dwm-uselessgap-20211119-58414bee958f2.diff
cd ..
cp config.h config.def.h
patch -i patches/alwayscenter.diff
sudo make clean install
cd ~
cd suckless/dwm
patch -i patches/uselessgap.diff
touch bk
cp config.h bk
sudo cp config.def.h config.h
cp bk config.def.h
rm bk
sudo make clean install
cd ~
cd suckless/dwm
patch -i patches/attachbelow
