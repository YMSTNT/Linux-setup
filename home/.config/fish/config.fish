if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Turn off fish welcome
set fish_greeting

# Starship
starship init fish | source

# Aliases
alias fishreload='source ~/.config/fish/config.fish'
alias lf='ls -la | grep'
alias ff='find | grep'
alias hisf='history | grep'
alias rmf='sudo rm -rf'
alias dnfi='sudo dnf install'
alias dnfr='sudo dnf remove'
alias dnfu='sudo dnf upgrade'
alias dnff='dnf list | grep'
alias dnffi='dnf list --installed | grep'
alias mexec='sudo chmod a+x'
alias cls='clear'

# Default command switch
alias ls='exa --color=always --group-directories-first --icons' # Fancier ls with icons
alias cat='bat --style rules --style snip --style changes --style header' # Fancier cat with better previews. Press q to quit
alias grep='rg -i --color=auto' # Faster grep

# Functions

# chown stuff
function chtnt
  sudo chown -R $USER $argv[1]
  sudo chgrp -R $USER $argv[1]
end

# Github SSH key maker
function ssh-make-key
  read -P 'Enter email: ' email
  ssh-keygen -t ed25519 -C $email
  bash -c 'eval "$(ssh-agent -s)"'
  ssh-add ~/.ssh/id_ed25519
  echo 'Add it to github via https://github.com/settings/ssh/new'
  echo '------------- PUBLIC KEY -------------'
  bat --style snip ~/.ssh/id_ed25519.pub
  echo '---------- END OF PUBLIC KEY ----------'
end

# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end
