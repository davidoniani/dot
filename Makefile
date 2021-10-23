# Makefile
# by David Oniani <onianidavid@gmail.com>
# License: MIT License

default: help

config: .config .local .zprofile
	cp       .zprofile $$HOME
	cp    -R .config   $$HOME
	cp    -R .local    $$HOME
	mkdir -p $${XDG_CACHE_HOME:-$$HOME/.cache}

help:
	printf "OPTIONS:\n \
		config      Copy configuration files\n \
		kitty       Install kitty terminal emulator\n \
		mpv         Install mpv media player\n \
		nnn         Install nnn file manager\n \
		packages    Install packages\n \
		python      Set up Python\n \
		rust        Set up Rust\n \
		zsh         Install Z Shell plugins\n"

kitty:
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
	ln -s $$HOME/.local/kitty.app/bin/kitty $$HOME/.local/bin/

mpv:
	git clone https://github.com/mpv-player/mpv
	cd mpv && ./bootstrap.py && ./waf configure && ./waf && ./waf install
	rm -rf mpv

nnn:
	git clone https://github.com/jarun/nnn
	cd nnn && make O_NERD=1 && sudo make install
	rm -rf nnn

packages:
	python3 -m pip install black trash-cli
	cargo install bat black fd-find

python:
	curl https://pyenv.run | bash

rust:
	curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh

zsh:
	rm -rf $${XDG_DATA_HOME:-$$HOME/.local/share}/zsh/plugin/zsh-autosuggestions
	rm -rf $${XDG_DATA_HOME:-$$HOME/.local/share}/zsh/plugin/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions \
	    $${XDG_DATA_HOME:-$$HOME/.local/share}/zsh/plugin/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting \
	    $${XDG_DATA_HOME:-$$HOME/.local/share}/zsh/plugin/zsh-syntax-highlighting

.SILENT: help
