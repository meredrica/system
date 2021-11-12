#ZSH setup
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="meredrica"
plugins=(battery)

# User configuration
export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/lib/node_modules:/usr/lib/jvm/default/bin"
# if i ever use python then i use pipenv
export PIPENV_VENV_IN_PROJECT=1
export EDITOR='nvim'
export SDKMAN_DIR="/home/meredrica/.sdkman"

source $ZSH/oh-my-zsh.sh

# developing localhost without security ftw
alias brave-insecure='brave --disable-web-security --user-data-dir=/home/meredrica/insecure'
# fuzzy history search
alias fh='function _fh(){ fh="$@"; history | fzf -m -q "$fh" };_fh'
# curl with defaults for dev
alias c='curl --insecure -vvv -H "Content-Type: application/json"'
# type less maven
alias mci="mvn clean install -T4C -ff"
# type less maven and fuck all thests
alias mcis="mvn clean install -T4C -ff -DskipTests"
# grep is hard
alias icanhaz='function _icanhaz(){ icanhaz="$@"; grep -HnIir --exclude-dir={.git,target,bin} "$icanhaz" -C3 .};_icanhaz'
# git log with relative date and author
alias gl="git log --graph --pretty=format:'%C(yellow)%h%Creset%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
# better stern output
alias stern="stern --template '{{color .PodColor .PodName}} {{.Message}}{{\"\n\"}}'"
# tag a project with a timestamp and push it
alias release='function _release(){ tag="$@"-$(date +'%Y-%m-%d_%H-%M'); echo $tag; git tag -a $tag && git push --tags};_release'
# fix ssh problems with alacritty
alias ssh='TERM=xterm-256color ssh'
# needs to be run for sdkman
[[ -s "/home/meredrica/.sdkman/bin/sdkman-init.sh" ]] && source "/home/meredrica/.sdkman/bin/sdkman-init.sh"
# switch to nvim from vim
alias vim=nvim
# better bat display
alias bat='bat --tabs 2 --theme ansi'
# i don't live in a 3rd world country
alias cal='cal -m'
# zsh awesomeness
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# oc completions
source <(oc completion zsh)
# autojump
source /usr/share/autojump/autojump.zsh
