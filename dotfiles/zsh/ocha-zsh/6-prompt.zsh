if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# primary prompt
PROMPT='$FG[237]------------------------------------------------------------%{$reset_color%}
$FG[051] ${_current_dir}$(git_prompt_info)$(_jobs_status)\
$FG[079]λ %{$reset_color%}'
PROMPT2='%{$fg[079]%}↳%{$reset_color%} '

RPS1='%${return_code}%'

# color vars
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'
local _current_dir="%{$fg[079]%}%3~%{$reset_color%} "

# current dir
function _current_dir() {
	local _max_pwd_length="225"
	if [[ $(echo -n $PWD | wc -c) -gt ${_max_pwd_length} ]]; then
		echo "%-6~ ... %6~"
	else
		echo "%~"
	fi
}

function _jobs_status() {
	JVAL="$(jobs | head -1 | grep -o '[0-9]' | tail -1)"
	if [ ! -z $JVAL ];
	then
		echo "$FG[075][$FG[078]$JVAL$FG[075]]%{$reset_color%}"
	fi
}

function _vi_status() {
	if {echo $fpath | grep -q "plugins/vi-mode"}; then
		echo "$(vi_mode_prompt_info)"
	fi
}

# right prompt
if type "virtualenv_prompt_info" > /dev/null
then
	RPROMPT='$(_vi_status)$(virtualenv_prompt_info)$my_gray%n@%m%{$reset_color%}%'
else
	RPROMPT='$(_vi_status)$my_gray%n@%m%{$reset_color%}%'
fi

function zle-line-init zle-keymap-select {
RPS1="${${KEYMAP/vicmd/- VI -}/(main|viins)/}"
RPS2=$RPS1
zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075][$FG[078]"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075]]%{$reset_color%}"
