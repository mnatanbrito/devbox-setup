# nvm configurations
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

####### custom aliases #######

# general purpose
alias reload="source ~/.zshrc"
alias show="ls -la "
alias rm-dir="rm -dRf "
alias ports="lsof -i -P -n | grep LISTEN"

# git
alias glog="git log --oneline"
alias gstatus="git status"
alias gshow="git show"
alias gpull="git pull"
alias gpause="git stash -u"
alias my-commits="git log --author=marcospachecodd"

# frontend
alias test="yarn test --findRelatedTests "
alias test-watch="yarn test --watch --findRelatedTests "

####### functions #######

# loads the version of nodejs based on the .nvmrc in the current directory
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

load-nvmrc