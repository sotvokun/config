if [[ $(uname) == "Darwin" ]]; then
    #homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Disable the message
    export BASH_SILENCE_DEPRECATION_WARNING=1
    export PATH="$PATH:/Users/sotvokun/.dotnet/tools"
fi
