#!/bin/bash
#My startup script

# update dnf configuration file
sudo sh -c 'echo "fastestmirror=True" >>/etc/dnf/dnf.conf'
sudo sh -c 'echo "deltarpm=true" >>/etc/dnf/dnf.conf'
sudo sh -c 'echo "max_parallel_downloads=10" >>/etc/dnf/dnf.conf'

# update hostname
sudo hostnamectl set-hostname desk-01

sudo dnf update && sudo dnf upgrade
sudo dnf remove libreoffice-* -y
sudo dnf remove firefox-* -y
sudo dnf autoremove
sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf update -y && sudo dnf upgrade -y
sudo fwupdmgr update
sudo fwupdmgr get-updates
sudo fwupdmgr update

# install h264 codecs
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf groupupdate sound-and-video -y
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia -y

# H/W Video Decoding
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y

# install theworks
sudo dnf install -y google-chrome neofetch gnome-extensions-app gnome-tweaks htop cool-retro-term lpf-mscore-fonts lpf-cleartype-fonts transmission terminology btop

# install fonts
sudo dnf copr enable dawid/better_fonts -y
sudo dnf install -y fontconfig-enhanced-defaults fontconfig-font-replacements --skip-broken
sudo dnf install -y 'google-roboto*' 'mozilla-fira*' fira-code-fonts

# install VS Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install -y code

# install Docker
sudo dnf -y install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl start docker
sudo docker run hello-world
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# install Steam
sudo dnf install -y steam

# enable flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# speed up grub
sudo dnf install grub-customizer
