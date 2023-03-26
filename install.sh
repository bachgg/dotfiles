#!/bin/sh

[[ ! -f ~/dotfiles ]] || git clone git@github.com:moppediert/dotfiles.git ~/dotfiles

ln -sf ~/dotfiles/.config/* ~/.config/

function install_git() {
	apt-get install -y git
}

function install_vscode() {
	cd /tmp
	curl -Ls -o vscode.deb -w %{url_effective} https://go.microsoft.com/fwlink/?LinkID=760868
	dpkg -i vscode.deb
}

function install_tmux() {
	cd /tmp
	apt-get install -y libevent-dev ncurses-dev build-essential bison pkg-config
	wget https://github.com/tmux/tmux/releases/download/3.3a/tmux-3.3a.tar.gz
	tar -zxf tmux-*.tar.gz
	cd tmux-*/
	./configure
	make
	make install
}

function install_rust() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source $HOME/.cargo/env
	cargo install alacritty starship exa
}

function install_neovim() {
	cd /tmp
	apt-get install -y ninja-build gettext libtool-bin cmake g++ pkg-config unzip curl
	git clone https://github.com/neovim/neovim
	cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
	make install

	# vim-plug
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

function install zsh() {
	apt-get install -y zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}