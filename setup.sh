#!/usr/bin/env bash

# shell profile
if [[ "$(uname)" == 'Windows_NT' ]]; then
	cp "Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1" \
		"$HOME/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
	cp .wslconfig "$HOME/.wslconfig"
else
	if [[ "$SHELL" =~ 'bash' ]]; then
		cp .profile "$HOME/.bashrc"
	elif [[ "$SHELL" =~ 'zsh' ]]; then
		cp .profile "$HOME/.zshrc"
	fi
fi

# gitconfig && gitexcludes
cat .gitconfig | sed 's/\#/\@/g' > "$HOME/.gitconfig"
cp .gitexcludes "$HOME/.gitexcludes"

# configs
cp -rf .config "$HOME/"
