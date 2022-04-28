#!/bin/fish

## Since there are user specific settings, force the user to run without sudo
if test $USER = "root"
  echo "Run this script without sudo!"
  exit
end 

## Aliases
alias dnfi='sudo dnf install -y'
alias dnfu='sudo dnf update -y'
alias dnfr='sudo dnf remove -y'

## Refresh the temporary directory
rm -vrf temp
mkdir -v temp
cd temp

function link
  ../link.fish $argv[1]
end

set packages
function queue
  set packages $packages $argv[1]
end

set delpackages
function delqueue
  set delpackages $delpackages $argv[1]
end

## Define an install process for every application

function firefox
  wget -O firefox-dev.tar.bz2 "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"
	tar xvf firefox-dev.tar.bz2
	sudo mv firefox /opt/firefox-dev
	sudo cp ../launchers/firefox-dev.desktop /usr/share/applications/firefox-dev.desktop
  sudo ln -s /usr/lib64/mozilla/native-messaging-hosts /usr/lib/mozilla/native-messaging-hosts # Required for gnome extensions add-on to work
end

function sublime_text
  sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
	sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
  dnfi sublime-text
end

function discord
  flatpak install flathub com.discordapp.Discord -y
end

function redshift
  queue redshift
  link .config/redshift.conf
end

function fish
  link .config/fish/config.fish
  link .config/starship.toml
end

function python
  queue python-pip
end

function flameshot
  dnfi flameshot
  # unbind default screenshot
  gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot-clip "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot "[]"
  gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot "[]"
  # bind all monitor screenshot (gnome)
  gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot-clip "['Print']"
  # bind focused window screenshot (gnome)
  gsettings set org.gnome.settings-daemon.plugins.media-keys window-screenshot-clip "['<Alt>Print']"
  # add insant and delayed (2 sec) screenshot (flameshot)
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[
		'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot-instant/',
		'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot-delayed/'
	]"
  # bind instant screenshot (flameshot)
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot-instant/ name 'flameshot-insant'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot-instant/ command 'flameshot gui'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot-instant/ binding '<Ctrl>Print'
  # bind delayed screenshot (flameshot)
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot-delayed/ name 'flameshot-delayed'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot-delayed/ command 'flameshot gui -d 2000'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot-delayed/ binding '<Ctrl><Shift>Print'
end

function git
  link .gitconfig
end

function vs_code
  queue code
  link .config/Code/User/settings.json
  # link .config/Code/User/keybindings.json
end

function java
  # java-8
  sudo rm /bin/java
  dnfi java-1.8.0-openjdk.x86_64
  sudo ln -sf /usr/lib/jvm/java-1.8.0-openjdk*/jre/bin/java /bin/java-8
  # java-17
  sudo rm /bin/java
  dnfi java-latest-openjdk.x86_64
  sudo ln -sf /usr/lib/jvm/java-17-openjdk*/bin/java /bin/java-17
  # default java is 17
  sudo ln -sf /bin/java-17 /bin/java
end

function nodejs
  queue nodejs
end

function csharp
  queue dotnet-sdk-6.0
end

function wine
  queue wine
end

function steam
  queue steam
end

function heroic
  flatpak install flathub com.heroicgameslauncher.hgl -y
  link .config/heroic/config.json
  link .config/heroic/GamesConfig/CrabEA.json
end

function multimc
  sudo cp ../launchers/multimc.desktop /usr/share/applications/multimc.desktop
	sudo mkdir /opt/multimc
	sudo chown $USER /opt/multimc
	sudo cp ../multimc/icon.svg /opt/multimc/icon.svg
	sudo cp ../multimc/run.sh /opt/multimc/run.sh
end

function minecraft
  flatpak install flathub org.polymc.PolyMC -y
  flatpak override org.polymc.PolyMC --filesystem=home
  flatpak install flathub com.mojang.Minecraft -y
end

function teams
  flatpak install flathub com.microsoft.Teams -y
end

#function fman
#  sudo rpm -v --import https://download.fman.io/rpm/public.gpg
#  sudo dnf config-manager --add-repo https://download.fman.io/rpm/fman.repo
#  sudo dnf install compat-openssl10
#  queue fman
#end

function obs
  queue obs-studio
end

function bitwarden
  flatpak install flathub com.bitwarden.desktop -y
end

function obsidian
  flatpak install flathub md.obsidian.Obsidian -y
end

function media_players
  queue vlc
  queue celluloid
end

function gimp
  queue gimp
end

function dbeaver
  flatpak install flathub io.dbeaver.DBeaverCommunity -y
end

function utilities
  flatpak install flathub dev.geopjr.Hashbrown -y
  flatpak install flathub org.gnome.World.PikaBackup -y
  flatpak install flathub re.sonny.Commit -y
  flatpak install flathub de.haeckerfelix.Fragments -y
end

function thunderbird
  flatpak install flathub org.mozilla.Thunderbird -y
  flatpak install flathub com.ulduzsoft.Birdtray -y
end

function terminal_autocomplete_case_insensitive
  if ! grep -Fq 'set completion-ignore-case on' /etc/inputrc
    echo 'set completion-ignore-case on' | sudo tee -a /etc/inputrc
  end
end

function gnome_keyboard_shortcuts
  # unbind conflict keys
  gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[]"
  gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
  gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
  # bind keys
  gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"                 # alt tab menu
  gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']" # alt tab menu go backwards
  gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>']"              # applications search
  gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>Left', '<Super>h']"   # resize window and fit to left
  gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>Right', '<Super>l']" # resize window and fit to right
  gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>Up', '<Super>k']"  # toggle maximize window
  gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>Down', '<Super>j']"        # minimize window
  gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"                          # close window
  gsettings set org.gnome.settings-daemon.plugins.media-keys magnifier "['<Super>z']"          # turn on zoom
  gsettings set org.gnome.settings-daemon.plugins.media-keys magnifier-zoom-in "['<Super>.']"  # zoom in
  gsettings set org.gnome.settings-daemon.plugins.media-keys magnifier-zoom-out "['<Super>-']" # zoom out
end

function gnome_extra
  queue gnome-tweak-tool
  flatpak install org.gnome.Extensions -y
  flatpak install flathub com.mattjakeman.ExtensionManager -y
end

function gnome_debloat
  delqueue gnome-weather
  delqueue gnome-maps
  delqueue gnome-clocks
  delqueue gedit
  delqueue cheese
  delqueue rhythmbox
  delqueue totem
  queue totem-video-thumbnailer # Required for video thumbnails in nautilus to work
  delqueue gnome-photos
  delqueue gnome-connections
  delqueue gnome-boxes
  delqueue gnome-tour
end

function extra_debloat
  delqueue mediawriter
end

## Call the install functions

if ! test -n "$argv"
  ################################################################
  ################################################################
  ################## CHOOSE YOUR TOOLS BELOW #####################
  ################################################################
  ################################################################
  firefox
  sublime_text
  discord
  redshift
  fish
  python
  flameshot
  vs_code
  java
  csharp
  wine
  steam
  heroic
  multimc
  minecraft
  teams
  #fman
  obs
  bitwarden
  obsidian
  media_players
  gimp
  dbeaver
  utilities
  thunderbird
  terminal_autocomplete_case_insensitive
  gnome_keyboard_shortcuts
  gnome_extra
  gnome_debloat
  extra_debloat
  ################################################################
  ################################################################
  ######################## END OF TOOLS ##########################
  ################################################################
  ################################################################
else
  for tool in $argv
    $tool
  end
end

# Install
if test -n "$packages"
  dnfi $packages
end

# Remove
if test -n "$delpackages"
  dnfr $delpackages
end

# Delete temp
cd ..
rm -rf temp