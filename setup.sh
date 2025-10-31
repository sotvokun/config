#!/usr/bin/env bash


# SECTION: variables
# -----------------------------------------------------------------------------
#
is_windows=0
if [[ "$(uname)" == 'Windows_NT' || "$(uname)" =~ 'MINGW' ]]; then
	is_windows=1
	export MSYS=winsymlinks:nativestrict
fi


# SECTION: shell profile
# -----------------------------------------------------------------------------
#
if [[ $is_windows -eq 1 ]]; then
	# Copy the PowerShell as the legacy profile
	if [[ ! -d "$HOME/Documents/WindowsPowerShell" ]]; then
		mkdir -p "$HOME/Documents/WindowsPowerShell"
	fi

	cp "Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1" \
		"$HOME/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"

	if [[ -n "$(command -v pwsh)" ]]; then
		rm -rf "$HOME/Documents/PowerShell"
		ln -s "$HOME/Documents/WindowsPowerShell" "$HOME/Documents/PowerShell"
	fi

	cp .wslconfig "$HOME/.wslconfig"
fi
if [[ "$SHELL" =~ 'bash' ]]; then
	cp .profile "$HOME/.bashrc"
elif [[ "$SHELL" =~ 'zsh' ]]; then
	cp .profile "$HOME/.zshrc"
fi


# SECTION: softwares
# -----------------------------------------------------------------------------
#
#    PART: gitconfig && gitexcludes
#
cat .gitconfig | sed 's/\#/\@/g' > "$HOME/.gitconfig"
cp .gitexcludes "$HOME/.gitexcludes"

#    PART: ideavimrc
cp .ideavimrc "$HOME/.ideavimrc"

#    PART: XDG_CONFIG_HOME
cp -rf .config "$HOME/"

#    PART: neovim
#        - 1. clean up the old neovim configuraiton
#        - 2. re-copy the new configs
#        - 3. create symbolic link for Windows
rm -rf "$HOME/.config/nvim"
cp -rf .config/nvim "$HOME/.config/nvim"
if [[ $is_windows -eq 1 && ! -h "$HOME/AppData/Local/nvim" ]]; then
	rm -rf "$HOME/AppData/Local/nvim"
	ln -s "$HOME/.config/nvim" "$HOME/AppData/Local/nvim"
fi

#    PART: alacritty setup
#        - 1. replace the alacritty.toml by the corresponding operating system
#        - 2. create symbolic link for Windows
if [[ $is_windows -eq 1 ]]; then
	mv "$HOME/.config/alacritty/alacritty.windows.toml" "$HOME/.config/alacritty/alacritty.toml"

	if [[ ! -h "$HOME/AppData/Roaming/alacritty" ]]; then
		rm -rf "$HOME/AppData/Roaming/alacritty"
		ln -s "$HOME/.config/alacritty" "$HOME/AppData/Roaming/alacritty"
	fi
fi

#    PART: vscode/cursor
if [[ $is_windows -eq 1 ]]; then
	if [[ -d "$HOME/AppData/Roaming/Code/User" ]]; then
		rm -f "$HOME/AppData/Roaming/Code/User/settings.json"
		rm -f "$HOME/AppData/Roaming/Code/User/keybindings.json"
		ln -s "$HOME/.config/vscode/settings.json" "$HOME/AppData/Roaming/Code/User/settings.json"
		ln -s "$HOME/.config/vscode/keybindings.json" "$HOME/AppData/Roaming/Code/User/keybindings.json"
	fi
	if [[ -d "$HOME/AppData/Roaming/Cursor/User" ]]; then
		rm -f "$HOME/AppData/Roaming/Cursor/User/settings.json"
		rm -f "$HOME/AppData/Roaming/Cursor/User/keybindings.json"
		ln -s "$HOME/.config/vscode/settings.json" "$HOME/AppData/Roaming/Cursor/User/settings.json"
		ln -s "$HOME/.config/vscode/keybindings.json" "$HOME/AppData/Roaming/Cursor/User/keybindings.json"
	fi
fi


# SECTION: WSL (Windows Only)
# -----------------------------------------------------------------------------
#
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
