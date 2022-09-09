
clone () {
  repo=$1
  destination=$2

  echo "Cloning $repo to $destination..."

  set -e

  if [[ ! -d $destination ]]; then
    mkdir -p $destination
    git clone $repo $destination
  fi

  set +e
}

timestamp () {
  date +"%T"
}

backup () {
  file=$1

  if [[ -e $file ]]; then
    echo "Backing up $file..."
    cp $file "$file.$(timestamp).backup"
  fi
}

symlink () {
  source=$1
  target=$2

  echo "Symlinking $1 as $2..."

  ln -sf $1 $2
}

ensure_directory () {
  directory=$1

  echo "Making directory $directory..."

  mkdir -p $directory
}



is_linux () { [[ "$OSTYPE" == *'linux'* ]]; }
is_osx () { [[ "$OSTYPE" == *'darwin'* ]]; }

install_debian_packages () {
  echo "Installing base packages for a Debian system..."

  set -e

  sudo apt -y update
  sudo apt -y upgrade
  sudo apt -y install \
    git \
    build-essential \
    alacritty \
    python-is-python3 \
    tmux \
    curl \
    wget \
    neovim \
    htop \
    gconf2 \
    clang-format \
    fonts-powerline \
    software-properties-common \
    silversearcher-ag

  wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg
  echo 'deb [signed-by=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list

  sudo apt update
  sudo apt install codium

  mkdir -p $HOME/Downloads

  if ! [ -x "$(command -v google-chrome)" ]; then
    curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > $HOME/Downloads/chrome.deb
    sudo dpkg -i $HOME/Downloads/chrome.deb
  fi

  if ! [ -x "$(command -v tailscale)" ]; then
    # See: https://tailscale.com/download/linux
    curl -fsSL https://tailscale.com/install.sh | sh
    echo "Starting up Tailscale; you will probably need to manually authenticate..."
    sudo tailscale up
  fi

  if ! [ -x "$(command -v starship)" ]; then
    # See: https://starship.rs/
    curl -sS https://starship.rs/install.sh | sh
  fi

  set +e
}

setup_dot_files() {
  echo "Setting up dot files..."

  home=$HOME
  repositories=$HOME/repositories
  config=$repositories/github.com/cdata/config

  set -e

  ensure_directory $repositories
  ensure_directory $home/.ssh
  ensure_directory $home/.config/nvim

  clone https://github.com/cdata/config.git $config

  backup $home/.bashrc
  backup $home/.bash_profile
  backup $home/.profile
  backup $home/.bash_login

  # Symlink dotfiles

  bashrc=$config/bash/rc

  symlink $bashrc $home/.bashrc
  symlink $bashrc $home/.bash_profile

  tmux_conf=$config/tmux/tmux.conf

  symlink $tmux_conf $home/.tmux.conf

  alacritty_conf=$config/alacritty/alacritty.yml

  ensure_directory $home/.config/alacritty
  symlink $alacritty_conf $home/.config/alacritty/alacritty.yml

  vscodium_settings_dir=$home/.config/VSCodium/User
  vscodium_settings=$config/vscode/settings.json

  ensure_directory $vscodium_settings_dir
  symlink $vscodium_settings $vscodium_settings_dir/settings.json

  # TODO: Re-evaluate what I want from a vim config
  # neovim_init=$config/neovim/init.vim
  # neovim_init_dir=$home/.config/nvim

  # ensure_directory $neovim_init_dir
  # symlink $neovim_init $neovim_init_dir/init.vim

  set +e
}

setup_fonts () {
  echo "Setting up fonts..."

  set -e

  font_install_dir=$HOME/.local/share/fonts
  cascadia_code_version="2111.01"

  # Delugia is Cascadia Code with Nerd Fonts
  pushd /tmp
  wget https://github.com/adam7/delugia-code/releases/download/v$cascadia_code_version/delugia-complete.zip
  unzip ./delugia-complete.zip
  ensure_directory $font_install_dir
  rm -f $font_install_dir/Delugia*.ttf
  cp -f ./delugia-complete/Delugia*.ttf $font_install_dir/
  popd

  # Cascadia Code doesn't currently support Nerd Fonts glyphs, but Nerd Fonts
  # glyphs are required to get the most out of Starship
  #pushd /tmp
  #wget https://github.com/microsoft/cascadia-code/releases/download/v$cascadia_code_version/CascadiaCode-$cascadia_code_version.zip
  #unzip ./CascadiaCode-$cascadia_code_version.zip
  #popd

  #ensure_directory $font_install_dir
  #pushd $font_install_dir
  #cp /tmp/ttf/Cascadia*.ttf ./
  #popd

  fc-cache -vf $font_install_dir

  set +e
}

setup_dev_environment () {
  echo "Setting up development environment..."

  set -e

  if ! [ -x "$(command -v rustup)" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  fi

  if ! [ -x "$(command -v nvm)" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  fi 

  git config --global user.name "Chris Joel"
  git config --global user.email "0xcda7a@gmail.com"
  git config --global init.defaultbranch "main"
  git config --global commit.gpgsign true
  git config --global user.signingkey "8D5E893F"

  echo "Initializing VSCodium..."

  code_extensions=(
    "max-ss.cyberpunk"
    "dbaeumer.vscode-eslint"
    "eamodio.gitlens"
    "esbenp.prettier-vscode"
    "runem.lit-plugin"
    "matklad.rust-analyzer"
    "vscodevim.vim"
    "bungcip.better-toml"
    "serayuzgur.crates"
    "antyos.openscad"
    #"dtsvet.vscode-wasm"
    "vadimcn.vscode-lldb"
  )

  # TODO: Setup Dracula Pro


  for extension in "${code_extensions[@]}"
  do
    codium --install-extension $extension
  done

  # echo "Initializing neovim..."
  # curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  #    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  # nvim +PlugInstall!

  set +e
}

if is_osx; then
  echo "You changed how this file works but didn't update the OSX steps dummy"
  exit 1
fi

if is_linux; then
  install_debian_packages
fi

setup_dot_files
setup_fonts
setup_dev_environment

echo "Done!"

set +e


