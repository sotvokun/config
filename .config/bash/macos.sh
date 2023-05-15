if [[ $(uname) == "Darwin" ]]; then
    #homebrew

    if [ -f '/opt/homebrew/bin/brew' ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Disable the message
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi
