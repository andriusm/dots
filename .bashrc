# sane mode
stty -ixon

# shopt -s autocd
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s histappend

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# unlimited history
HISTSIZE=
HISTFILESIZE=

# source ~/.functions
source ~/.aliases

#export TERM=xterm+256colors
#xhost +local:root > /dev/null 2>&1
#complete -cf sudo

# enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

RESET="$(tput sgr0)"

BLUE="$(tput setaf 4)"
GREEN="$(tput setaf 2)"
GREY="$(tput setaf 244)"
RED="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"

git_prompt() {
  BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\(.*\)/\1/')

  if [ ! -z "$BRANCH" ]; then
    echo -n "$YELLOW$BRANCH"

    if [ ! -z "$(git status --short)" ]; then
      echo " ${RED}✗"
    fi
  fi
}

#PS1=" \[$BLUE\w$(git_prompt)\] \[$GREY\]$ \[$RESET\]"

eval "$(rbenv init -)"

DEV_TOOLS_DIR="$HOME/work/projects/dev-tools"
source "${DEV_TOOLS_DIR}/bin/shell_function.sh"

source $HOME/.docker/init-bash.sh || true # Added by Docker Desktop

DOCKER_DEFAULT_PLATFORM=linux/amd64

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/andrejus/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

source "${DEVTOOLS_PATH:-$HOME/vinted/dev-tools}/bin/shell_function.sh"
