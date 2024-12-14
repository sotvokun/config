#!/usr/bin/env bash

# variables
is_windows=0
if [[ "$(uname)" == 'Windows_NT' || "$(uname)" =~ 'MINGW' ]]; then
	is_windows=1
fi

# shell profile
if [[ $is_windows -eq 1 ]]; then
	cp "Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1" \
		"$HOME/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
	cp .wslconfig "$HOME/.wslconfig"
fi
if [[ "$SHELL" =~ 'bash' ]]; then
	cp .profile "$HOME/.bashrc"
elif [[ "$SHELL" =~ 'zsh' ]]; then
	cp .profile "$HOME/.zshrc"
fi

# gitconfig && gitexcludes
cat .gitconfig | sed 's/\#/\@/g' > "$HOME/.gitconfig"
cp .gitexcludes "$HOME/.gitexcludes"

# ideavimrc
cp .ideavimrc "$HOME/.ideavimrc"

# configs
cp -rf .config "$HOME/"

# symbolic link for neovim on Windows
if [[ $is_windows -eq 1 && ! -h "$HOME/AppData/Local/nvim" ]]; then
	rm -rf "$HOME/AppData/Local/nvim"
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
