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

function asdf_current_version() {
    echo $(asdf current $1 | grep -o '[0-9.]*' | awk 'NR==1')
}
