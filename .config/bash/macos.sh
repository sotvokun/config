if [[ $(uname) == "Darwin" ]]; then
    #homebrew
    if [ -f '/opt/homebrew/bin/brew' ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Disable the message
    export BASH_SILENCE_DEPRECATION_WARNING=1

    # asdf
    if [ -f '/opt/homebrew/opt/asdf/libexec/asdf.sh' ]; then
        . /opt/homebrew/opt/asdf/libexec/asdf.sh
    fi

    # alias for remove com.apple.quarantine
    alias rm_quarantine='xattr -d com.apple.quarantine'

    # openjdk
    if [ -d '/opt/homebrew/opt/openjdk' ]; then
        export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
    fi

    # dotnet
    if [ -d '/usr/local/share/dotnet' ]; then
        export PATH="/usr/local/share/dotnet:$PATH"
        export PATH="$HOME/.dotnet/tools:$PATH"
    fi

    # PHP 8.1
    if [ -d '/opt/homebrew/opt/php@8.1' ]; then
        export PATH="/opt/homebrew/opt/php@8.1/bin:$PATH"
        export PATH="/opt/homebrew/opt/php@8.1/sbin:$PATH"
    fi

    # LLVM
    if [ -d '/opt/homebrew/opt/llvm' ]; then
        export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
    fi
fi
