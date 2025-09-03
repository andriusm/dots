#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

source $HOME/.docker/init-bash.sh || true # Added by Docker Desktop

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/andrejus/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
