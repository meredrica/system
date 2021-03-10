# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="meredrica"

# Add wisely, as too many plugins slow down shell startup.
plugins=(colorize battery autojump thefuck helm)

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
export PATH="$PATH:/usr/lib/node_modules"
export PATH="$PATH:/usr/lib/jvm/default/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export DOCKER_BUILDKIT=1
export PIPENV_VENV_IN_PROJECT=1
# developing localhost without security ftw
alias brave-insecure='brave --disable-web-security --user-data-dir=/home/meredrica/insecure'
# fuzzy history search
alias fh='function _fh(){ fh="$@"; history | fzf -m -q "$fh" };_fh'
# curl with defaults for dev
alias c='curl -vvv -H "Content-Type: application/json" $@'
# make stuff silent (╯°□°)╯︵ ┻━┻
alias stfu="$@ > /dev/null 2>&1"
# type less maven
alias mci="mvn clean install -T4C -ff $@"
# grep is hard
alias icanhaz='function _icanhaz(){ icanhaz="$@"; grep -HnIir --exclude-dir={.git,target,bin} "$icanhaz" -C3 .};_icanhaz'
# git log with relative date and author
alias gl="git log --graph --pretty=format:'%C(yellow)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
# better stern output
alias stern="stern --template '{{color .PodColor .PodName}} {{.Message}}{{\"\n\"}}'"
# i don't want to type this
alias todo="todotxt-machine"
# tag a project with a timestamp and push it
alias release='function _release(){ tag="$@"-$(date +'%Y-%m-%d_%H-%M'); echo $tag; git tag -a $tag && git push --tags};_release'

alias ssh='TERM=xterm-256color ssh'
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/meredrica/.sdkman"
[[ -s "/home/meredrica/.sdkman/bin/sdkman-init.sh" ]] && source "/home/meredrica/.sdkman/bin/sdkman-init.sh"
