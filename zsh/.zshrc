# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

source $ZDOTDIR/constants
source $ZDOTDIR/aliases
source $ZDOTDIR/functions

# autoload -Uz compinit && compinit
##zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

#setopt AUTO_CD
setopt NO_CASE_GLOB
setopt NO_CASE_MATCH
setopt AUTO_MENU
setopt GLOB_COMPLETE
setopt COMPLETE_ALIASES
setopt COMPLETE_IN_WORD
setopt NO_LIST_AMBIGUOUS
setopt NO_LIST_BEEP

unsetopt BEEP

#history
setopt SHARE_HISTORY
HISTFILE=${ZDOTDIR}/.zsh_history
SAVEHIST=5000
HISTSIZE=2000
setopt HIST_EXPIRE_DUPS_FIRST 
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS

bindkey -e
bindkey '^R' history-incremental-search-backward

# if [[ -e ~/.rbenv ]]; then
#   export PATH=~/.rbenv/shims:~/.rbenv/bin:$PATH
#   eval "$(rbenv init -)"
# fi
#

if [[ -e /opt/homebrew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#   [[ -f /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme ]] && . /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
#   [[ -f /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme ]] && . /opt/homebrew/opt/powerlevel10k/share/powerlevel10k/powerlevel10k.zsh-theme

export PATH="$HOME/bin:$HOME/go/bin:$PATH"
export GOPATH="$HOME/go"

# To customize prompt, run `p10k configure` or edit ~/Sync/config/mac/zsh/.p10k.zsh.
# [[ ! -f ~/Sync/config/mac/zsh/.p10k.zsh ]] || source ~/Sync/config/mac/zsh/.p10k.zsh

# source $HOME/.docker/init-zsh.sh || true # Added by Docker Desktop
# fpath=(~/.zsh/completion /opt/homebrew/share/zsh/site-functions $fpath)
# autoload -Uz compinit && compinit -i

autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

# --------------------------------------------------------------------------------

git_branch() {
  local branch=""
  # Check if the current directory is in a Git repository
  if git rev-parse --git-dir > /dev/null 2>&1; then
    # Get the name of the current branch
    branch=$(git branch --show-current)
    # If the branch is not empty, echo it with formatting
    if [ -n "$branch" ]; then
      echo "$branch"
    fi
  fi
}

# PROMPT="%F{blue}%~ $(git_branch) %F{cyan}%B%%%b%f "

RPROMPT=$'%{\e[38;2;0;0;0m\e[48;2;166;175;184m%} %* %k%f'

autoload -Uz add-zsh-hook
load_prompt() {
  PROMPT_BASE=$'%{\e[38;2;255;255;255m\e[48;2;70;130;180m%} %~ %k%{\e[38;2;70;130;180m\e[48;2;124;200;68m%}%{\e[38;2;0;0;0m\e[48;2;124;200;68m%} '
  PROMPT_END=$' %k%{\e[38;2;124;200;68m%} %k%f%# '
  PROMPT="$PROMPT_BASE$(git_branch)$PROMPT_END"
}
add-zsh-hook precmd load_prompt
