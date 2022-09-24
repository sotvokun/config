#RUSTUP
export RUSTUP_HOME=".local/rustup"
export CARGO_HOME=".local/cargo"
if [[ -f "$HOME/.local/cargo/env" ]]; then
    source "$HOME/.local/cargo/env"
fi
