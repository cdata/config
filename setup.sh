
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
    tmux \
    curl \
    wget \
    neovim \
    clang-format \
    fonts-powerline \
    software-properties-common \
    silversearcher-ag

  wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
  sudo apt-add-repository 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main'
  sudo apt update
  sudo apt install codium

  mkdir -p $HOME/Downloads

  curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > $HOME/Downloads/chrome.deb

  sudo dpkg -i $HOME/Downloads/chrome.deb

  curl -fsSL https://starship.rs/install.sh > $HOME/Downloads/install-starship.sh
  sudo bash $HOME/Downloads/install-starship.sh -y

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

  vscodium_settings_dir=$home/.config/VSCodium/User
  vscodium_settings=$config/vscode/settings.json

  ensure_directory $vscodium_settings_dir
  symlink $vscodium_settings $vscodium_settings_dir/settings.json

  neovim_init=$config/neovim/init.vim
  neovim_init_dir=$home/.config/nvim

  ensure_directory $neovim_init_dir
  symlink $neovim_init $neovim_init_dir/init.vim

  set +e
}

setup_dev_environment () {
  echo "Setting up development environment..."

  set -e

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

  git config --global user.name "Chris Joel"
  git config --global user.email "chris@scriptolo.gy"

  # Install powerline fonts

  font_install_dir=$HOME/.local/share/fonts
  ensure_directory $font_install_dir
  pushd $font_install_dir
  wget https://github.com/microsoft/cascadia-code/releases/latest/download/CascadiaPL.ttf
  popd

  fc-cache -vf $font_install_dir

  echo "Initializing VSCodium..."

  code_extensions=(
    "xaver.clang-format"
    "max-ss.cyberpunk"
    "dbaeumer.vscode-eslint"
    "eamodio.gitlens"
    "cesium.gltf-vscode"
    "slevesque.shader"
    "vscodevim.vim"
  )

  for extension in "${code_extensions[@]}"
  do
    codium --install-extension $extension
  done

  echo "Initializing neovim..."

  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  nvim +PlugInstall!

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
setup_dev_environment

echo "Done!"

set +e


