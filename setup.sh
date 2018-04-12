
clone () {
  repo=$1
  destination=$2

  echo "Cloning $repo to $destination..."

  mkdir -p $destination

  set -e
  git clone $repo $destination
  set +e
}

backup () {
  file=$1

  if [[ -e $file ]]; then
    echo "Backing up $file..."
    mv $file $file.backup
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

install_osx_base () {
  echo "Installing base packages for an OSX system..."

  set -e

  `which xcode-select` --install
  `which ruby` -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  brew install git
  brew install tmux
  brew install wget
  brew install nvm
  brew install python3
  brew install clang-format
  brew install ag
  # Slow:
  #brew install bash-completion

  brew tap caskroom/fonts
  brew cask install font-hack-nerd-font-mono

  brew install caskroom/cask/iterm2
  brew install neovim/neovim/neovim
  brew install caskroom/cask/spectacle
  brew install caskroom/cask/licecap
  brew install caskroom/cask/flux
  brew install caskroom/cask/keycastr
  brew linkapps

  set +e
}

install_debian_base () {
  echo "Installing base packages for a Debian system..."

  set -e

  sudo apt-get -yq update
  sudo apt-get -yq upgrade
  sudo apt-get -yq install git build-essential openssh-server neovim tmux python3 python3-pip curl clang-format silversearcher-ag

  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

  set +e
}

install_common_base () {
  echo "Installing base packages common to all systems..."

  set -e

  nvm install --lts

  npm install -g neovim
  npm install -g typescript

  pip3 install --upgrade neovim

  git config --global user.name "Chris Joel"
  git config --global user.email "chris@scriptolo.gy"

  set +e
}

home=$HOME
repositories=$HOME/repositories
config=$repositories/config
vendor=$config/vendor

set -e

ensure_directory $repositories
ensure_directory $home/.ssh
ensure_directory $home/.config/nvim

clone https://github.com/cdata/config.git $config

ensure_directory $vendor

clone https://github.com/gioele/bashrc_dispatch.git $vendor/bashrc_dispatch

backup $home/.bashrc
backup $home/.bash_profile
backup $home/.profile
backup $home/.bash_login

# Symlink dotfiles

bashrc_dispatch=$vendor/bashrc_dispatch/bashrc_dispatch
bash=$config/bash

symlink $bashrc_dispatch $home/.bashrc
symlink $bashrc_dispatch $home/.bash_profile
symlink $bashrc_dispatch $home/.profile
symlink $bashrc_dispatch $home/.bash_login

symlink $bash/rc_all $home/.bashrc_all
symlink $bash/rc_interactive $home/.bashrc_interactive
symlink $bash/rc_login $home/.bashrc_login
symlink $bash/rc_script $home/.bashrc_script

tmux=$config/tmux

symlink $tmux/tmux.conf $home/.tmux.conf

neovim=$config/neovim

symlink $neovim/init.vim $home/.config/nvim/init.vim

# Install important packages

if is_osx; then
  install_osx_base
fi

if is_linux; then
  install_debian_base
fi

install_common_base

# Set up Neovim

echo "Initializing neovim..."

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugInstall!

echo "Done!"

set +e

