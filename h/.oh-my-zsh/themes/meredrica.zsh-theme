setopt PROMPT_SUBST
autoload -U colors
colors
# set up colors
# user color
if [ $UID -eq 0 ]; then user_color="red"; else user_color="magenta"; fi
# ssh color
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then ssh_color="yellow"; else ssh_color="green"; fi
# git symbol color
local git_symbol_color="cyan"
# now use the colors and define some variables for the prompts
# last return code as green or red smiley
local return_code="%(?.%{$fg_bold[green]%}:)%{$reset_color%}.%{$fg_bold[red]%}:(%{$reset_color%})"
# user bold and in user color
local user="%{$fg_bold[$user_color]%}%n%{$reset_color%}"

#host bold and in ssh color
local host="%{$fg_bold[$ssh_color]%}%m%{$reset_color%}"

#if we are in an scm repo we want a special char to be displayed in color, otherwhise the promt in user color
function prompt_char() {
		git branch >/dev/null 2>/dev/null && echo "%{$fg_bold[$git_symbol_color]%}±%{$reset_color%}" && return
		echo "%{$fg_bold[$user_color]%}>%{$reset_color%}"
}

function scm_info() {
	echo "$(git_prompt_info)"
}
# the path, with home as ~
function path_info() {
	echo "${PWD/#$HOME/~}"
}



# set up the various git stuffs
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[yellow]%}<"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[yellow]%}>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} ! "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[blue]%} ? "
ZSH_THEME_GIT_PROMPT_CLEAN=""
#user@host path git_promt_info promt_char
PROMPT='${user}@${host} $(path_info)$(scm_info) ${return_code} $(prompt_char) '
# current time in 24hh:mm:ss
RPROMPT="%*"
