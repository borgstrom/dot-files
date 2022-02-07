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