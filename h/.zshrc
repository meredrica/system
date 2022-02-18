# TODO
# - https://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
# - split into multiple files
#
# completions
autoload -U compinit
# color support
autoload -U colors
# up arrow history magic
autoload -U up-line-or-beginning-search
# down arrow history magic
autoload -U down-line-or-beginning-search

# enable colors in shell commands
colors
# completions
compinit -i

# smart case
# TODO: figure out this syntax.
zstyle ':completion:*' matcher-list '' '+m:{a-zA-Z}={A-Za-z}' '+r:|[._-]=* r:|=*' '+l:|=* r:|=*'

# prompt setup
# some of this stuff is ripped out of zsh plugins
function battery_prompt() {
	local charging=$(! acpi 2>/dev/null | command grep -v "rate information unavailable" | command grep -q '^Battery.*Discharging')
	local battery_pct=$(acpi 2>/dev/null | command awk -F, '
		/rate information unavailable/ { next }
		/^Battery.*: /{ gsub(/[^0-9]/, "", $2); print $2; exit }
	')
	if [ $charging ] || [ ! $battery_pct ]; then
		echo ""
	else
  # Sample output:
	# Battery 0: Discharging, 0%, rate information unavailable
	# Battery 1: Full, 100%
		local color;
		if [[ $battery_pct -gt 50 ]]; then
			color='green'
		elif [[ $battery_pct -gt 20 ]]; then
			color='yellow'
		else
			color='red'
		fi
		echo " %{$fg[$color]%}${battery_pct}%%"
	fi
}

function git_prompt() {
	# FIXME: use the vcs_info stuff from here https://voracious.dev/a-guide-to-customizing-the-zsh-shell-prompt
	local git_color="%{$fg[yellow]%}"
	local info=$(git status --porcelain --branch 2>/dev/null)
	local prompt;
	local changes='';
	if [[ $info == \#\#* ]]; then;
		# we have a branch
		# check if there are changes
		if [[ $( echo $info | grep -c '^') > 1  ]]; then;
			changes="%{$fg_bold[red]%}!$git_color";
		fi
		if [[ $info == *no\ branch* ]]; then
			# no branch info
			prompt=$(git rev-parse --short HEAD 2>/dev/null)
		else
			# branch name is the second field
			prompt=$(git branch --show-current 2>/dev/null);
		fi
		echo " $git_color<$prompt$changes>%{$reset_color%}";
	fi;
}

# the path, with home as ~
path_prompt() {
	echo "${PWD/#$HOME/~}"
}
# user color
if [ $UID -eq 0 ]; then user_color="red"; else user_color="magenta"; fi
# ssh color
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then ssh_color="yellow"; else ssh_color="green"; fi
# now use the colors and define some variables for the prompts
# last return code as green or red smiley
local return_code="%(?.%{$fg_bold[green]%}:)%{$reset_color%}.%{$fg_bold[red]%}:(%{$reset_color%})"
# user bold and in user color
local user="%{$fg_bold[$user_color]%}${USERNAME[1]}%{$reset_color%}"

#host bold and in ssh color
local host="%{$fg_bold[$ssh_color]%}%m%{$reset_color%}"

local return_code="%(?.%{$fg_bold[green]%}:).%{$fg_bold[red]%}:()%{$reset_color%}"

# current time in 24hh:mm:ss, battery status
RPROMPT='%*$(battery_prompt)%{$reset_color%}'

PROMPT='$user@${host} $(path_prompt)$(git_prompt) ${return_code} '

export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/lib/node_modules:/usr/lib/jvm/default/bin"

# if I ever use python then I use pipenv
export PIPENV_VENV_IN_PROJECT=1
export EDITOR='nvim'
export SDKMAN_DIR="/home/meredrica/.sdkman"

# set the history file location
HISTFILE="$HOME/.zsh_history"
# set the max size
HISTSIZE=50000
# set the maximum history length
SAVEHIST=10000

# colorize grep
alias grep='grep --color'
# show full history
alias history='history 1'
# colorize ls
alias ls='ls --color=auto'
# lazy shorthand
alias l='ls -la'
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
alias release='function _release(){ tag="$@"/$(date +'%Y-%m-%d_%H-%M'); echo $tag; git tag -a $tag && git push origin $tag};_release'
# fix ssh problems with alacritty
alias ssh='TERM=xterm-256color ssh'
# switch to nvim from vim
alias vim=nvim
# better bat display
alias bat='bat --tabs 2 --theme ansi'
# i don't live in a 3rd world country
alias cal='cal -m'

# needs to be run for sdkman
[[ -s "/home/meredrica/.sdkman/bin/sdkman-init.sh" ]] && source "/home/meredrica/.sdkman/bin/sdkman-init.sh"
# zsh awesomeness
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# oc completions
source <(oc completion zsh)
# autojump
source /usr/share/autojump/autojump.zsh
# source all scripts
for f (~/.config/zsh/*.zsh) source $f

# prompt variable substitution
setopt promptsubst
# record timestamp of command in HISTFILE
setopt extended_history
# ignore duplicated commands history list
setopt hist_ignore_dups
# ignore commands that start with space
setopt hist_ignore_space
# show command with history expansion to user before running it
setopt hist_verify
# share command history data
setopt share_history
# push to the dir stack automatically
setopt auto_pushd
# bind key up to history magic
bindkey "^[[A" up-line-or-beginning-search # Up
# bind key down to history magic
bindkey "^[[B" down-line-or-beginning-search # Down

# enable up arrow history magic
zle -N up-line-or-beginning-search
# enable down arrow history magic
zle -N down-line-or-beginning-search

# menu completion highlighting
zstyle ':completion:*' menu select
