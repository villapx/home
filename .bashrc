# use UTF-8 encoding
export LANG=en_US.UTF-8

# aliases
alias la="ls -la"
alias rm="rm -i"
alias cp="cp -i"
alias datetime="date +%m-%d-%Y_%H%M%S"

# enable color support for ls if it's available
command -v dircolors >/dev/null 2>&1 &&
    {
        eval "$(dircolors)" >/dev/null 2>&1;
        alias ls="ls --color=auto";
    }

# gnome-terminal doesn't set the TERM variable to xterm-256color, though it does
#   support 256 colors. for gnome-terminal version < 3.13, the COLORTERM
#   variable is set, so we know we can use xterm-256color
# apparently, gnome-terminal versions >= 3.13 set VTE_VERSION instead. we'll
#   tackle that when we get there
if [ "$COLORTERM" = "gnome-terminal" ] && [ "$TERM" = "xterm" ]
then
    export TERM=xterm-256color
fi

# set important environment variables
export EDITOR=vim
export GREP_OPTIONS='--color=auto'

# set prompt
ncolors=$(tput colors)
if test -n "$ncolors" && test $ncolors -ge 8
then
    bold="$(tput bold)"
    underline="$(tput smul)"
    standout="$(tput smso)"
    normal="$(tput sgr0)"
    black="$(tput setaf 0)"
    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    yellow="$(tput setaf 3)"
    blue="$(tput setaf 4)"
    magenta="$(tput setaf 5)"
    cyan="$(tput setaf 6)"
    white="$(tput setaf 7)"
fi
PS1="\[${bold}${yellow}\]\u\[${normal}\]@\h:\w $ "

umask 2  # prevent "others" from getting write permission on created files

# source site-specific rc file, if it exists and is readable
if [ -r ~/.bashrc-site ]
then
    source ~/.bashrc-site
fi

