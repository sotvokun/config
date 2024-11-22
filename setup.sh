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

# ideavimrc
cp .ideavimrc "$HOME/.ideavimrc"

# configs
cp -rf .config "$HOME/"

# symbolic link for neovim on Windows
if [[ "$(uname)" == 'Windows_NT' && ! -h "$HOME/AppData/Local/nvim" ]]; then
	ln -s "$HOME/.config/nvim" "$HOME/AppData/Local/nvim"
fi

# wsl setup
if [[ "$(uname)" == 'Linux' ]]; then
	if [[ $(grep -i Microsoft /proc/version) ]]; then
		/mnt/c/Windows/System32/where.exe /Q git-credential-manager
		if [[ $? == 0 ]]; then
			gcm_win_path=$(/mnt/c/Windows/System32/where.exe git-credential-manager)
			gcm_path=$(echo $gcm_win_path | sed 's|\\|/|g; s|C:|/mnt/c|' | sed 's/ /\\ /g')
			git config --global credential.helper "$gcm_path"
		fi
	fi
fi
