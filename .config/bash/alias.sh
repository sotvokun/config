# Set the colorful ls
alias ls='ls --color=auto'

# fzf powered
alias fcd="cd ~ && cd \$(fd -H -t d --exclude .git | fzf --ansi --prompt='cd> ')"

