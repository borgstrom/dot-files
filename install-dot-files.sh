#!/bin/bash
#
# This script installs all of my dot-files
#

DOTFILES=$( cd $(dirname $0) ; pwd -P )

cd $DOTFILES

# update our submodules
git submodule init
git submodule update --recursive
cd .vim/bundle/jedi-vim/
git submodule init
git submodule update --recursive

cd $DOTFILES

for ent in .bash_profile .bashrc .screenrc .vim .vimrc .tmux.conf; do
	if [ -e ~/$ent ]; then
		if [ ! -h ~/$ent ]; then
			mv ~/$ent ~/$ent.before-dot-files
		fi
	fi

	ln -sf $DOTFILES/$ent ~/$ent
done

# special case .ssh/rc
[ ! -d ~/.ssh ] && mkdir ~/.ssh && chmod 0700 ~/.ssh
ln -sf $DOTFILES/.ssh/rc ~/.ssh/rc

# special case nvim config
[ ! -d ~/.config/nvim ] && mkdir -p ~/.config/nvim
ln -sf $DOTFILES/nvim-init.vim ~/.config/nvim/init.vim
