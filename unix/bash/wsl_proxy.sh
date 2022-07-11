if [[ $(uname --kernel-release | grep microsoft) ]]; then
    export ALL_PROXY="http://$(cat /etc/resolv.conf | grep nameserver | cut -f 2 -d ' '):7890"
fi
