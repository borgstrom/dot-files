#!/bin/bash
#
# This script installs all of my dot-files
#

DOTFILES=$( cd $(dirname $0) ; pwd -P )

for ent in .bashrc .screenrc .vim .vimrc; do
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
