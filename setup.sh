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

# vim
if [[ "$(uname)" == 'Windows_NT' ]]; then
	echo 'source ~/.config/nvim/init.vim' > "$HOME/_vimrc"
else
	echo 'source ~/.config/nvim/init.vim' > "$HOME/.vimrc"
fi

# neovim for windows
if [[ "$(uname)" == 'Windows_NT' ]]; then
	ln -sf "$HOME/.config/nvim/" "$HOME/AppData/Local/nvim"
fi

# configs
cp -rf .config "$HOME/"
