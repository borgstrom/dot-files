#!/bin/bash
#
# This script installs all of my dot-files
#

DOTFILES=$( cd $(dirname $0) ; pwd -P )

for ent in .bashrc .screenrc .vim .vimrc; do
	if [ -e ~/$ent ]; then
		if [ ! -h ~/$ent ]; then
			echo "Failed to install $ent, it already exists and is not a link"
			continue
		fi
	fi

	ln -s $DOTFILES/$ent ~/$ent
done

# special case .ssh/rc
[ ! -d ~/.ssh ] && mkdir ~/.ssh && chmod 0700 ~/.ssh
ln -s $DOTFILES/.ssh/rc ~/.ssh/rc
