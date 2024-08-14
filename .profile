export LANG=en_US.UTF-8
export EDITOR=nvim

BIN="$HOME/.local/bin"
if ! echo $PATH | egrep --quiet "(^|:)$BIN($|:)" ; then
    export PATH="$BIN:$PATH"
fi

# rust/cargo
if [ -r "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

if [ -n "$BASH" ]; then
    source ~/.bash_profile
fi
