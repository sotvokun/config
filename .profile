# NOTE: if not running interactively, don't do anything
[[ "$-" != *i* ]] && return


# `is_windows`
is_windows=0
if [[ "$(uname)" == 'Windows_NT' || "$(uname)" =~ 'MINGW' ]]; then
	is_windows=1
fi


# options
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
if [[ "$SHELL" =~ 'bash' ]]; then
	shopt -s histappend
	shopt -s checkwinsize
fi

case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac


# ~/.local/bin
if ! [[ "$PATH" =~ "$HOME/.local/bin:" ]]; then
	PATH="$HOME/.local/bin:$PATH"
fi
export PATH


# MacOS
if [[ "$(uname)" == "Darwin" ]]; then
	# alias for remove com.apple.quarantine
	alias rm_quarantine='xattr -d com.apple.quarantine'
	# homebrew
	if [ -f '/opt/homebrew/bin/brew' ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
fi


# bash_completion: programmable completion
if [[ "$SHELL" =~ 'bash' && "$(uname)" != 'Darwin' ]]; then
	if ! shopt -oq posix; then
		if [ -f /usr/share/bash-completion/bash_completion ]; then
			. /usr/share/bash-completion/bash_completion
		elif [ -f /etc/bash_completion ]; then
			. /etc/bash_completion
		fi
	fi
fi


# asdf
if [[ -d "$HOME/.asdf" ]]; then
	. "$HOME/.asdf/asdf.sh"
	if [[ "$SHELL" =~ 'bash' ]]; then
		. "$HOME/.asdf/completions/asdf.bash"
	fi
	if [[ "$SHELL" =~ 'zsh' ]]; then
		fpath=(${ASDF_DIR}/completions $fpath)
		autoload -Uz compinit && compinit
	fi
fi


# mise-en-place
if [[ $is_windows -eq 0 && -n $(command -v mise) ]]; then
	SHELL_BASENAME="$(basename $SHELL)"
	eval "$(mise activate $SHELL_BASENAME)"
fi


# Prompt
NEWLINE=$'\n'
if [[ $UID -eq 0 ]]; then
	export PS1='\[\e[1m\]\u@\h\[\e[0m\] \[\e[31m\]\w\[\e[0m\]\n# '
	export PROMPT="%f%B%n@%m%b %F{1}%~%f${NEWLINE}# "
else
	export PS1='\[\e[1m\]\u@\h\[\e[0m\] \[\e[32m\]\w\[\e[0m\]\n$ '
	export PROMPT="%f%B%n@%m%b %F{2}%~%f${NEWLINE}$ "
fi


alias ls='ls --color=auto'

# {ba,z}shrc.local
if [[ "$SHELL" =~ 'bash' ]]; then
	[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
elif [[ "$SHELL" =~ 'zsh' ]]; then
	[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
fi

# vim: ft=bash ft=sh
