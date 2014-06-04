# ------------------------------------------------------------------------------
# FILE        : twoline.zsh-theme
# DESCRIPTION : oh-my-zsh theme file
# AUTHOR      : Eli Gundry (eligundry@gmail.com)
# VERSION     : 2.0.0
# ------------------------------------------------------------------------------

# Constants
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FX[bold]%}%{$FG[002]%}[:"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=":"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="]%{$reset_color%}"

ZSH_THEME_RVM_PROMPT_PREFIX=" %{$FX[bold]%}%{$FG[001]%}["
ZSH_THEME_RVM_PROMPT_SUFFIX="]%{$reset_color%} "

ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=" %{$FX[bold]%}%{$FG[003]%}["
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="]%{$reset_color%} "

function _prompt_dir() {
	local before_dir='╭─'
	local current_dir="%{$FX[bold]%}%{$FG[004]%}[%~]%{$reset_color%}"

	echo -n "${before_dir}${current_dir}"
}

function _prompt_git() {
	local git_info="%{$(git_prompt_info)%}%{$(git_prompt_short_sha)%}"

	echo -n "${git_info}"
}

# Change prompt icon color based up previous command
# Green: All good
# Red: Bad command
# Yellow: Root
# Cyan: Background task
function _prompt_icon() {
	local icon="\n╰"

	if [[ $RETVAL -ne 0 ]]; then
		icon+="%{$FX[bold]%}%{$FG[001]%}⤭%{$reset_color%}"
	elif [[ $UID -eq 0 ]]; then
		icon+="%{$FX[bold]%}%{$FG[003]%}⤭%{$reset_color%}"
	elif [[ $(jobs -l | wc -l) -gt 0 ]]; then
		icon+="%{$FX[bold]%}%{$FG[006]%}⤭%{$reset_color%}"
	else
		icon+="%{$FX[bold]%}%{$FG[002]%}⤭%{$reset_color%}"
	fi

	echo -n "$icon"
}

function _rprompt_time()
{
	local current_time=" %{$FX[bold]%}%{$FG[004]%}[%T]%{$reset_color%}"

	echo -n "$current_time"
}

function _rprompt_rvm()
{
	echo -n "$(ruby_prompt_info)"
}

function _rprompt_ssh() {
	if [[ -n $SSH_CONNECTION ]]; then
		echo " %{$FX[bold]%}%{$FG[002]%}[ssh]%{$reset_color%}"
	fi
}

function _rprompt_virtualenv() {
	local name

	if [ -n "$VIRTUAL_ENV" ]; then
		if [ -f "$VIRTUAL_ENV/__name__" ]; then
			local name=`cat $VIRTUAL_ENV/__name__`
		elif [ `basename $VIRTUAL_ENV` = "__" ]; then
			local name=$(basename $(dirname $VIRTUAL_ENV))
		else
			local name=$(basename $VIRTUAL_ENV)
		fi

		echo -n "$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX$name$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"
	fi
}

build_prompt()
{
	RETVAL=$?
	_prompt_dir
	_prompt_git
	_prompt_icon
}

build_rprompt()
{
	_rprompt_rvm
	_rprompt_ssh
	_rprompt_virtualenv
	_rprompt_time
}

PROMPT='
$(build_prompt) '
RPROMPT='$(build_rprompt)'
