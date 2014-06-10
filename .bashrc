# return on non-interactive shells - don't put anything that might produce output above here...
[[ $- != *i* ]] && return

###
### Evan Borgstrom's .bashrc file
### Latest at https://github.com/borgstrom/dot-files
###

###
### Global Configuration
###

# pull in global profile
if [ -f /etc/profile ]; then
	. /etc/profile
fi

# a nice liberal path with our own local items first
export PATH="$HOME/bin:$HOME/local/bin:$HOME/local/sbin:$PATH:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin"

# our dotfiles config
export DOTFILES=$(cd $(dirname $(readlink ~/.bashrc)) ; pwd -P)
export DOTFILES_REMOTE="https://github.com/borgstrom/dot-files.git"
export DOTFILES_REF="heads/master"
export DOTFILES_CHECK_INTERVAL=43200 # 12 hours

###
### Custom Functions
###
randompass() {
        local MATRIX="HpZld&xsG47f0)W^9gNa!)LR(TQjh&UwnvP(tD5eAzr6k@E&y(umB3^@!K^cbOCV)SFJoYi2q@MIX8!1"
        local PASS=""
        local n=1
        local i=1
	local length=8
	local num=1
        [ -z "$1" ] || length=$1
        [ -z "$2" ] || num=$2
        while [ ${i} -le $num ]; do
                while [ ${n} -le $length ]; do
                        PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
                        n=$(($n + 1))
                done
                echo $PASS
                n=1
                PASS=""
                i=$(($i + 1))
        done
}

ps1_git_branch() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	git diff --quiet 2>/dev/null >&2 && dirty="" || dirty="●"
	echo " git:${ref#refs/heads/}${dirty}"
}

num_users() {
	who | wc -l | tr -d ' '
}

num_jobs() {
	jobs -s | wc -l | tr -d ' '
}


login-info() {
	local loadavg=''
	if [ ! -r /proc/loadavg ]; then
		loadavg=$(uptime | awk -F'[a-z]:' '{print $2}' | awk -F' ' '{print $1}')
	else
		loadavg=$(awk '{print $2}' /proc/loadavg)
	fi

	if [ $(echo "${loadavg}>2" | bc -l) -eq 1 ]; then
		echo "Load average is above 2.0, skipping login info..."
		return
	fi

	# these arrays hold our login info items
	# the index of the names array matches the index of the output array
	local command_names
	local command_output

	command_names[0]="disks > 90%"
	command_output[0]=$(df -lk 2>/dev/null | grep -v '^Filesystem' | awk '{ if ($5 > 90) { print $0 } }')

	command_names[1]="zombies"
	command_output[1]=$(ps aux | grep ' Z. ' | grep -v grep)

	command_names[2]="dotfiles"
	command_output[2]=$(check-dot-files)

	# output it all
	echo ""
	echo -e "${USER} login to ${HOSTNAME} - $(date)"
	uptime
	echo ""

	# i is our loop iteration
	local i=0

	# l is the length of dashes needed to make a flush 80.
	# dashes & fulldashes are strings used in output
	local l=0
	local dashes=""
	local fulldashes=$(printf "%80s" | tr ' ' '-')

	# loop through our login_info items
	while [ $i -lt ${#command_names[@]} ]; do
		# only show commands with output
		if [ ! -z "${command_output[$i]}" ]; then
			# build the amount of dashes needed to make a flush 80
			l=$((80 - 7 - ${#command_names[$i]}))
			dashes=$(printf "%${l}s" | tr ' ' '-')
			echo "---( ${command_names[$i]} )$dashes"

			# show our output, use printf so that our newlines are shown
			printf "${command_output[$i]}\n"

			echo $fulldashes
		fi

		# next
		i=$(($i + 1))
	done
}

check-dot-files() {
	local CACHE_FILE=/tmp/.check-dot-files.${USER}
	local TIMESTAMP=0
	if [ -f $CACHE_FILE ]; then
		if [ "$(uname)" == "Darwin" ]; then
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
	OWD=$(pwd)
	cd $DOTFILES
	git pull --recurse-submodules origin
	cd $OWD
	rm -f /tmp/.check-dot-files.${USER}
}

osx-ssh-agent-timeout() {
	# on os x we want ssh-agent to timeout our keys once an hour
	# this gives us a nice balance of security and convenience
	PLIST="/System/Library/LaunchAgents/org.openbsd.ssh-agent.plist"
	LOCK="/tmp/.osx-ssh-agent-timeout-check"
	SKIP="~/.osx-ssh-agent-timeout-skip"

	# if our plist doesn't exist, or our lock or skip does exist return
	[ ! -f "$PLIST" ] || [ -f "$LOCK" ] || [ -f "$SKIP" ] && return

	ARGS=`defaults read $PLIST ProgramArguments`
	if [ -z "`echo $ARGS | grep -- '-t'`" ]; then
		echo ""
		echo "*** OS X - SSH AGENT TIMEOUT ***"
		echo
		echo "Your machine is set to run ssh-agent without a timeout."
		echo "Let's edit the ssh-agent launchctl plist file to add a"
		echo "timeout of one hour."
		echo
		echo "You will now be prompted for your password since sudo"
		echo "needs to be used to update this setting."
		echo
		echo "If you don't want to do this just hit CTRL+C when prompted"
		echo "for your password, and then run:"
		echo "touch $SKIP"
		echo

		sudo defaults write $PLIST ProgramArguments '("/usr/bin/ssh-agent", "-l", "-t", "3600")'

		# os x oddity; by default we're able to read the file without
		# being root but as soon as we write to the file we need to
		# change the mode because it sets 0600
		sudo chmod 0644 $PLIST
	fi

	touch $LOCK
}

###
### Shell customization
###

# page with less
[ -x $(which less) ] && export PAGER=less || echo "WARNING: more sucks, install less"

# edit with vim
[ -x $(which vim) ] && export EDITOR=vim || {
	[ -x $(which vi) ] && export EDITOR=vi || echo "WARNING: couldn't find vi or vim"
}

# shell options
shopt -s cdspell        # correct minor spelling mistakes in directory names for cd
shopt -s checkwinsize   # keep the LINES & COLUMNS variables updated
shopt -s cmdhist        # save multi-line commands as a single history entry
shopt -s lithist        # multi-line commands in the history should maintain the newlines
shopt -u dotglob        # do not glob files that begin with a period in expansion
shopt -s extglob        # add extended globing
shopt -s histappend     # append the history to HISTFILE instead of overwriting
shopt -s histreedit     # allow for re-edits on failed history commands
shopt -s histverify     # verify history command before passing it to the shell
shopt -s checkhash      # ensure a hash command exists before re-executing, otherwise search in PATH
shopt -s promptvars     # ensure our prompt is parsed
shopt -s checkwinsize   # make sure bash updates our window size so that lines wrap properly
set -o notify           # report on terminated background jobs immediately
set -o ignoreeof        # dont log out on eof (^D)

# set our umask
umask 022

# screen should be xterm
[ $TERM == "screen" ] && export TERM=xterm

# find out some info about our term capabilities
term_colour=0
case $TERM in
	xterm*|color_xterm|rxvt|Eterm|screen*|linux)
	term_colour=1
	;;
esac

if [ ${term_colour} -eq 1 ]; then
        BLACK='\[\e[0;30m\]'
        BLUE='\[\e[0;34m\]'
        GREEN='\[\e[0;32m\]'
        CYAN='\[\e[0;36m\]'
        RED='\[\e[0;31m\]'
        PURPLE='\[\e[0;35m\]'
        BROWN='\[\e[0;33m\]'
        LIGHTGRAY='\[\e[0;37m\]'
        DARKGRAY='\[\e[1;30m\]'
        YELLOW='\[\e[1;33m\]'
        WHITE='\[\e[1;37m\]'
        NC='\[\e[m\]'
fi

# dircolors
if [ ${term_colour} -eq 1 ] && ( dircolors --help && ls --color ) &> /dev/null; then
        if [[ -f ~/.dir_colors ]]; then
                eval `dircolors -b ~/.dir_colors`
        elif [[ -f /etc/DIR_COLORS ]]; then
                eval `dircolors -b /etc/DIR_COLORS`
        fi
        alias ls="ls --color=auto"
        alias ll="ls --color=auto -al"
        alias grep="grep --colour"
else
        alias ls="ls -F"
        alias ll="ls -Fal"
fi

# set window title
case $TERM in
        xterm*|rxvt*|Eterm)
		export PROMPT_COMMAND='echo -ne "\033]2;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
                ;;
        screen*)
		export PROMPT_COMMAND='echo -ne "\033]2;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007\033k${HOSTNAME}\033\\"'
                ;;
esac

# my prompt
# http://i.imgur.com/jfYidAv.png
[ ${EUID} -eq 0 ] && user_colour="${RED}" || user_colour="${LIGHTGRAY}"
PROMPT1="${user_colour}\u@\h ${BLUE}\w${NC} — u:\$(num_users) j:\$(num_jobs)\$(ps1_git_branch) (\D{%H:%M:%S %m.%d})"
export PS1="\n${PROMPT1}\n#\! ${user_colour}❯❯❯${NC} "

# use the bash-completion package if we have it
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
[ -f /etc/bash_completion ] && source /etc/bash_completion

complete 2>&1 >/dev/null
if [ $? = 0 ]; then
        # completion entries
        complete -A alias       alias unalias
        complete -A command     which
        complete -A export      export printenv
        complete -A hostname    ssh telnet ftp ncftp ping dig nmap
        complete -A helptopic   help
        complete -A job -P '%'  fg jobs
        complete -A setopt      set
        complete -A shopt       shopt
        complete -A signal      kill killall
        complete -A user        su userdel passwd
        complete -A group       groupdel groupmod newgrp
        complete -A directory   cd rmdir
fi

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
alias poweroff='echo "Please run /sbin/poweroff to turn off the system"'

# only run pip with virtualenv and use the active env
export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true

# see if we have a custom set of init actions to include
test -r ~/.bash_custom && . ~/.bash_custom

# login info
login-info

# os x ssh agent check
osx-ssh-agent-timeout

