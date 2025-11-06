# vim: set filetype=bash :

export LANG=en_US.UTF-8
export EDITOR=nvim

# prevent "others" from getting write permission on created files
umask 2

# function to avoid adding duplicate entries to the variable given in $1
#   e.g.
#     varmunge PATH ~/.local/bin after
varmunge ()
{
    case ":${!1}:" in
        *:"$2":*)
            ;;
        *)
            if [[ "$3" = "after" ]]; then
                eval "$1=\"\${$1:+\$$1:}$2\""
            else
                eval "$1=\"$2\${$1:+:\$$1}\""
            fi
    esac
}

export -f varmunge

varmunge PATH ~/.local/bin

# rust/cargo
if [[ -r "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi

# source site-specific bash_profile file, if it exists and is readable
if [[ -r ~/.bash_profile-site ]]; then
    source ~/.bash_profile-site
fi

# if this is an interactive shell, source .bashrc
case "$-" in
    *i*) source ~/.bashrc
esac
