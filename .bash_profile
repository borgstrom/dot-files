# a nice liberal path with our own local items first
export PATH="$HOME/bin:$HOME/local/bin:$HOME/local/sbin:$PATH:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin"

# screen should be xterm
[ $TERM == "screen" ] && export TERM=xterm

# load our bashrc
[ -r ~/.bashrc ] && . ~/.bashrc
