#!/bin/bash

## Enable RPM Fusion
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf update -y

##Enable flathub

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update

## Install additional multimedia codecs

sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video

##DNF flags

if ! grep -Fq 'fastestmirror=1' /etc/dnf/dnf.conf; then
  echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
fi
if ! grep -Fq 'max_parallel_downloads=10' /etc/dnf/dnf.conf; then
  echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
fi
if ! grep -Fq 'deltarpm=true' /etc/dnf/dnf.conf; then
  echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
fi

sh -c "$(curl -fsSL https://starship.rs/install.sh)"           # custom prompt
sudo dnf install fish                                          # bash alt
sudo dnf install exa                                           # ls alt
sudo dnf install ripgrep                                       # grip alt
sudo dnf install bat                                           # cat alt
