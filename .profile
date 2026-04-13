export LANG="en_US.UTF-8"
export EDITOR="nvim"

# prevent "others" from getting write permission on created files
umask 2

BIN="${HOME}/.local/bin"
if ! echo "$PATH" | egrep --quiet "(^|:)${BIN}($|:)" ; then
    export PATH="${BIN}:${PATH}"
fi

# rust/cargo
if [ -r "${HOME}/.cargo/env" ]; then
    . "${HOME}/.cargo/env"
fi

# go
for dir in /usr/local/go/bin ~/go/bin ; do
    if ! echo "$PATH" | egrep --quiet "(^|:)${dir}($|:)" ; then
        export PATH="${PATH}:${dir}"
    fi
done

if [ -n "$BASH" ]; then
    . ~/.bash_profile
fi
