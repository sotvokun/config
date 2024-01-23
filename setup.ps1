# Copy .config folder
Copy-Item -Recurse -Force ./.config ~/
Copy-Item -Force ./.gitconfig ~/
Copy-Item -Force ./.vimrc ~/
Copy-Item -Force ./.wslconfig ~/
