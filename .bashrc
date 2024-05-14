# ~/.bashrc: executed by bash(2) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


# NOTE: if not running interactively, don't do anything
# NOTE: DO NOT CHANGE THE SPACES TO TAB
case $- in
	*i*) ;;
	*) return;;
esac


# options
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac


# ~/.local/bin
if ! [[ "$PATH" =~ "$HOME/.local/bin:" ]]; then
	PATH="$HOME/.local/bin:$PATH"
fi
export PATH


# bash_completion: programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# asdf
if [[ -d "$HOME/.asdf" ]]; then
	. "$HOME/.asdf/asdf.sh"
	if [[ $SHELL =~ bash ]]; then
		. "$HOME/.asdf/completions/asdf.bash"
	fi
	if [[ $SHELL =~ zsh ]]; then
		fpath=(${ASDF_DIR}/completions $fpath)
		autoload -Uz compinit && compinit
	fi
fi


# MacOS
if [[ $(uname) == "Darwin" ]]; then
	# alias for remove com.apple.quarantine
	alias rm_quarantine='xattr -d com.apple.quarantine'

	if [ -f '/opt/homebrew/bin/brew' ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
fi


# Prompt
NEWLINE=$'\n'
if [ $UID -eq 0 ]; then
	export PS1='\[\e[1m\]\u@\h\[\e[0m\] \[\e[31m\]\w\[\e[0m\]\n# '
	export PROMPT="%f%B%n@%m%b %F{1}%~%f${NEWLINE}# "
else
	export PS1='\[\e[1m\]\u@\h\[\e[0m\] \[\e[32m\]\w\[\e[0m\]\n$ '
	export PROMPT="%f%B%n@%m%b %F{2}%~%f${NEWLINE}$ "
fi


alias ls='ls --color=auto'

[ -f "$HOME/.bashrc.local" ] && source $HOME/.bashrc.local

# vim: ft=sh
