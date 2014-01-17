# return on non-interactive shells - don't put anything that might produce output above here...
[[ $- != *i* ]] && return

# page with less
[ -x $(which less) ] && export PAGER=less || echo "WARNING: more sucks, install less"

# edit with vim
[ -x $(which vim) ] && export EDITOR=vim || {
	[ -x $(which vi) ] && export EDITOR=vi || echo "WARNING: couldn't find vi or vim"
}

# a nice liberal path that covers pretty much all of my machines and their
# sometimes goofy directory layout in $HOME
export PATH="$HOME/bin:$HOME/local/bin:$HOME/local/sbin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin/:/usr/java/bin"

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
                PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
                ;;
        screen)
                PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
                ;;
esac

# Evan's prompt:
# user@host /working/path - u:users j:jobs [git:branch] (timestamp)

_git_branch() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	git diff --quiet 2>/dev/null >&2 && dirty="" || dirty="●"
	echo "git:${ref#refs/heads/}${dirty}"
}

_num_users() {
	who | wc -l | tr -d ' '
}

_num_jobs() {
	jobs -s | wc -l | tr -d ' '
}

[ ${EUID} -eq 0 ] && user_colour="${RED}" || user_colour="${LIGHTGRAY}"

PROMPT1="${user_colour}\u${LIGHTGRAY}@\h ${BLUE}\w${NC} — u:\$(_num_users) j:\$(_num_jobs) \$(_git_branch) (\D{%H:%M:%S %m.%d})"
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

# lastly run some simple checks and output some info
disk_usage_file="/tmp/.login.${USER}.$$.diskusage"
zombies_file="/tmp/.login.${USER}.$$.zombies"

# check if there are any partitions > 90% used
df -lk | grep -v "^Filesystem" | awk '{ if ($5 > 90) { print $0 } }' > ${disk_usage_file}

# check if there are any zombie processes
ps aux | grep " Z. " | grep -v grep > ${zombies_file}

# output it all
echo ""
echo -e "${USER} login to `hostname` - `date`"
uptime
echo ""

if [ -s ${disk_usage_file} ]; then
        echo "---( disks >90% )------------------------------------------------------"
        cat ${disk_usage_file}
        echo "-----------------------------------------------------------------------"
fi

if [ -s ${zombies_file} ]; then
        echo "---( zombies )---------------------------------------------------------"
        cat ${zombies_file}
        echo "-----------------------------------------------------------------------"
fi

# clean up
/bin/rm -f /tmp/.login.${USER}.$$.*

# see if we have the fink init.sh (ie; we're on a mac)
test -r /sw/bin/init.sh && . /sw/bin/init.sh

# see if we have a custom set of init actions to include
test -r ~/.bash_custom && . ~/.bash_custom

####
#### custom functions below here
####
tail64n() {
        [ ! -x "/usr/bin/tai64nlocal" ] && echo "tai64nlocal not installed, please install daemontools..." && return
        [ ! -f "$1" ] && echo "Usage: tail64n <file>" && return
        /usr/bin/tail -f $1 | /usr/bin/tai64nlocal
}

randompass() {
	words=/usr/share/dict/words
	if [ ! -f $words ]; then
		echo "$words doesn't exist. Sorry..."
		return
	fi

	numlines=`wc -l $words | awk '{print $1}'`
	numwords=0

	JOINERS="!.:*^@%&"
	joiner=${JOINERS:$(($RANDOM % ${#JOINERS})):1}
	password=""

	while [ $numwords -lt 3 ]; do
		linenum=$(($RANDOM % $numlines + 1))

		word=`sed -n ${linenum}p $words | perl -e "print ucfirst(<>);"`
		[ ! -z "$password" ] && password="${password}${joiner}${word}" || password=$word

		numwords=$(($numwords + 1))
	done

	echo $password
}

old_randompass() {
        MATRIX="HpZld&xsG47f0)W^9gNa!)LR(TQjh&UwnvP(tD5eAzr6k@E&y(umB3^@!K^cbOCV)SFJoYi2q@MIX8!1"
        PASS=""
        n=1
        i=1
        [ -z "$1" ] && length=8 || length=$1
        [ -z "$2" ] && num=1 || num=$2
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

fbpasswd() {
        perl -I/opt/fatbox/lib -MFatBox::Password -e "print FatBox::Password->generate($1) . \"\n\";"
}

pyactivate() {
        [ -z "$PYTHONENV" ] && PYTHONENV="${HOME}/python-envs"
        ACTFILE="${PYTHONENV}/$1/bin/activate"
        if [ ! -f "$ACTFILE" ]; then
                echo "No such environment in ${PYTHONENV} (${ACTFILE})"
        else
                source $ACTFILE
        fi
}

commit() {
        git=/usr/bin/git
        $git diff $* > /tmp/.git.commit
        EDITOR='vim -c "vsp /tmp/.git.commit"' git commit $*
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
