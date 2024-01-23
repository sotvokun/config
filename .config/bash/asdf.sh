if [[ -d "$HOME/.asdf" ]]; then
    . "$HOME/.asdf/asdf.sh"
fi

if [[ $SHELL =~ bash ]]; then
    . "$HOME/.asdf/completions/asdf.bash"
fi

if [[ $SHELL =~ zsh ]]; then
    fpath=(${ASDF_DIR}/completions $fpath)
    autoload -Uz compinit && compinit
fi
