export LANG=en_US.UTF-8
export EDITOR=vim

BIN="$HOME/.local/bin"
if ! echo $PATH | egrep --quiet "(^|:)$BIN($|:)" ; then
    export PATH="$BIN:$PATH"
fi

if [ -n "$BASH" ]; then
    source ~/.bash_profile
fi
