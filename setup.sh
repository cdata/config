
clone () {
	repo=$1
	destination=$2

	echo "Cloning $repo to $destination..."

	mkdir -p $destination
	git clone $repo $destination
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

	set +e
	`which xcode-select` --install
	`which ruby` -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	brew install git
	brew install tmux
	brew install wget
	brew install nvm
	brew install python3
	brew install neovim/neovim/neovim
	brew install caskroom/cask/spectacle
	brew install caskroom/fonts/font-hack
	brew linkapps
	set -e
}

install_debian_base () {
	echo "Installing base packages for a Debian system..."

	set +e

	sudo apt-get -yq update
	sudo apt-get -yq upgrade
	sudo apt-get -yq install git build-essential openssh-server neovim tmux python3

	set -e
}

install_common_base () {
	echo "Installing base packages common to all systems..."

	set +e

	pip3 install neovim

	set -e
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

nvim +PlugInstall! +qall!

set +e

