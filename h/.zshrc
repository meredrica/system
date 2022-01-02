#ZSH setup
##### Battery percentage for rprompt
function battery_is_charging() {
		! acpi 2>/dev/null | command grep -v "rate information unavailable" | command grep -q '^Battery.*Discharging'
}
function battery_pct() {
  # Sample output:
	# Battery 0: Discharging, 0%, rate information unavailable
	# Battery 1: Full, 100%
	acpi 2>/dev/null | command awk -F, '
		/rate information unavailable/ { next }
		/^Battery.*: /{ gsub(/[^0-9]/, "", $2); print $2; exit }
	'
}

function battery_pct_prompt() {
	if battery_is_charging; then
		echo ""
	else
	local battery_pct=$(battery_pct)
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
### end of battery rprompt

# current time in 24hh:mm:ss, battery status
RPROMPT='%*$(battery_pct_prompt)%{$reset_color%}'

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="meredrica"

export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/lib/node_modules:/usr/lib/jvm/default/bin"
# if I ever use python then i use pipenv
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
