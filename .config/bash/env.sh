# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# rustup
export RUSTUP_HOME="$HOME/.local/share/rustup"
export CARGO_HOME="$HOME/.local/share/cargo"
if [[ -f "$CARGO_HOME/env" ]]; then
    source "$CARGO_HOME/env"
fi
