#!/bin/sh

DOTFILES=$( cd $(dirname $0) ; pwd -P )

git submodule init
git submodule update --recursive

for ent in .zshrc .zprofile .p10k.zsh .screenrc .tmux.conf; do
    if [ -e ~/$ent ]; then
		if [ ! -h ~/$ent ]; then
			mv ~/$ent ~/$ent.before-dot-files
		fi
	fi

	ln -sf $DOTFILES/$ent ~/$ent
done