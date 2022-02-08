# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export DOTFILES=$(cd $(dirname $(readlink ~/.zshrc)) ; pwd -P)

# Load powerlevel10k
source ${DOTFILES}/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Homebrew
[ -x /opt/homebrew/bin/brew ] && eval $(/opt/homebrew/bin/brew shellenv)

# pyenv
[ -x $(which pyenv) ] && eval "$(pyenv init -)"

# command aliases - be paranoid & fix typos
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias iv='vi'
alias sl='ls'
alias vp='cp'
alias mb='mv'
alias grpe='grep'
alias gpre='grep'
alias whcih='which'
alias snv='svn'

# git shortcuts
alias gcv='git commit -v'
alias gco='git checkout'
alias gb='git branch'
alias gpu='git push origin -u HEAD'
alias gpfu='git push origin -f -u HEAD'
alias gfo='git fetch origin'
alias grom='git rebase origin/master'
alias grod='git rebase origin/develop'

# our dotfiles config
if [ -h ~/.zshrc ]; then
	export DOTFILES=$(cd $(dirname $(readlink ~/.zshrc)) ; pwd -P)
else
	export DOTFILES=""
fi
export DOTFILES_REMOTE="https://github.com/borgstrom/dot-files.git"
export DOTFILES_REF="heads/master"
export DOTFILES_CHECK_INTERVAL=43200 # 12 hours
export GIT_EXECUTABLE=$(which git 2>/dev/null)

check-dot-files() {
	[ -z $DOTFILES ] && return
	local CACHE_FILE=/tmp/.check-dot-files.${USER}
	local TIMESTAMP=0
	if [ -f $CACHE_FILE ]; then
		if [ "$(uname)" = "Darwin" ]; then
			eval $(stat -s $CACHE_FILE)
			TIMESTAMP=$st_mtime
		else
			TIMESTAMP=$(stat -c %Y $CACHE_FILE)
		fi
	fi

	local NOW=$(date +%s)
	local DIFF=$(($NOW - $TIMESTAMP))

	# only update the remote cache once every check interval
	if [ $DIFF -gt $DOTFILES_CHECK_INTERVAL ]; then
		echo $(git ls-remote $DOTFILES_REMOTE $DOTFILES_REF | awk '{print $1}') > $CACHE_FILE
	fi

	local REMOTE_SHA1=$(<$CACHE_FILE)
	local LOCAL_SHA1=$(GIT_DIR=$DOTFILES/.git git show-ref $DOTFILES_REF | awk '{print $1}')

	if [ "$REMOTE_SHA1" != "$LOCAL_SHA1" ]; then
		echo "Your dot-files are out of date!"
		echo "To update them run: update-dot-files"
	fi
}

update-dot-files() {
	[ -z $DOTFILES ] && return
	OWD=$(pwd)
	cd $DOTFILES
	git pull --recurse-submodules origin
	cd $OWD
	rm -f /tmp/.check-dot-files.${USER}
}

check-dot-files
