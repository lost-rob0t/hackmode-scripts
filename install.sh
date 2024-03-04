#!/usr/bin/env sh

## Install Hackmode!
if [ -f /etc/os-release ]; then
    # Source the file to load the variables
    . /etc/os-release
    OS="$NAME"
fi


function install_config() {
    mkdir -p $HOME/.config/hackmode
    mkdir -p $HOME/.local/share/hackmode
    touch $HOME/.config/hackmode/hackmoderc
    echo """export HACKMODE_OP=$(cat ~/.local/share/hackmode/current-op | head -n 1)
export HACKMODE_PATH=$(cat ~/.local/share/hackmode/op-path | head -n 1)
export HACKMODE_BASE_DIR=\"/home/$USER/Documents/hackmode/\"
function shm() {
  selected_dir=$(find \"$HACKMODE_BASE_DIR\" -maxdepth 1 -type d | fzf)
  if [ -n \"$selected_dir\" ]; then
    export HACKMODE_OP=$(basename \"$selected_dir\")
    export HACKMODE_PATH=\"$selected_dir\"
    echo \"$HACKMODE_OP\" > ~/.local/share/hackmode/current-op
    echo \"$HACKMODE_PATH\" > ~/.local/share/hackmode/op-path
    cd \"$selected_dir\"
  fi
}

function hackmode-setting() {
  if [ -z \"$HACKMODE_OP\" ]; then
    echo \"HACKMODE_OP is not set. Please select a hackmode directory using 'shm' first.\"
    return 1
  fi

  settings_dir=\"$HACKMODE_PATH/.config/$HACKMODE_OP\"

  # Create settings directory if it doesn't exist
  if [ ! -d \"$settings_dir\" ]; then
    mkdir -p \"$settings_dir\"
    read -p \"Enter the name of the setting: \" setting_name
  else
    setting_name=$(basename =$(find \"$settings_dir\" -type f | fzf ))
  fi

  # Use the specified editor or fallback to a default editor (e.g., nano)
  editor=${VISUAL:-$EDITOR}
  editor=${editor:-nano}

  # Prompt user for setting name
  if [ -n \"$setting_name\" ]; then
    setting_file=\"$settings_dir/$setting_name\"
    $editor \"$setting_file\"
  else
    echo \"Setting name cannot be empty.\"
  fi
}


function list-hackmode-settings () {

  if [ -z \"$HACKMODE_OP\" ]; then
    echo \"HACKMODE_OP is not set. Please select a hackmode directory using 'shm' first.\"
    return 1
  fi

  settings_dir=\"$HACKMODE_PATH/.config/\"

  if [ ! -d \"$settings_dir\" ]; then
    echo \"Settings directory not found: $settings_dir\"
    return 1
  fi

  for setting_file in \"$settings_dir\"/*; do
    setting_name=$(basename \"$setting_file\")

    if [ -f \"$setting_file\" ]; then
      while IFS= read -r line; do
        echo \"$setting_name: $line\"
      done < \"$setting_file\"
    fi
  done
}

alias cdhm=\"cd $HACKMODE_PATH\"
""" >> $HOME/.config/hashmode/hackmoderc
    echo "Hackmode config file located at:  $HOME/.config/hackmode/hackmoderc"
}

function install_source() {
    find ./source/ -type f | xargs -I {} cp {} "$HOME/.local/bin/{}"
    chmod +x $HOME/.local/bin/*
}

function install_nixos() function install_source() {
    find ./source/ -type f | xargs -I {} cp {} "$HOME/.local/bin/{}"
    chmod +x $HOME/.local/bin/*
}

{
    echo "Installing Nixos...."
    curl --output /tmp/nixos.sh https://nixos.org/nix/install
    bash /tmp/nixos.sh --no-daemon
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
}


function install_bashrc() {
    echo """source $HOME/.config/hackmoderc""" >> $HOME/.bashrc
}

function full_install() {
    echo "Full Install WILL install nixos for deps, if you want to avoid this use --light"
    install_nixos
    install_bashrc
    install_source
}


function update() {
    git pull && install_source
}

install_source
install_bashrc
install_config
