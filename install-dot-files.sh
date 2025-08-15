#!/bin/sh

DOTFILES=$( cd $(dirname $0) ; pwd -P )

for ent in .zshrc .zprofile .screenrc .tmux.conf .starship.toml; do
    if [ -e ~/$ent ]; then
	    if [ ! -h ~/$ent ]; then
		    mv ~/$ent ~/$ent.before-dot-files
	    fi
    fi

    ln -sf $DOTFILES/$ent ~/$ent
done

[[ -x $(which fwdproxy-config) ]] && FWDPROXY_CURL=$(fwdproxy-config curl)

[[ ! -d $HOME/bin ]] && mkdir $HOME/bin
BIN_DIR=$HOME/bin curl $FWDPROXY_CURL -sS https://starship.rs/install.sh | sh
