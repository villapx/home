# aliases
alias cp="cp -i"
alias datetime="date +%m-%d-%Y_%H%M%S"
alias grep="grep --color=auto"
alias la="ls -la"
alias mv="mv -i"
alias psef="ps -ef"
alias rm="rm -i"

# don't put duplicate consecutive commands in the history
HISTCONTROL=ignoredups

# history length in the shell and in the .bash_history file
HISTSIZE=1000
HISTFILESIZE=2000

# make 'less' more friendly for non-text input files (see lesspipe(1))
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support for ls if it's available
command -v dircolors >/dev/null 2>&1 &&
    {
        eval "$(dircolors)" >/dev/null 2>&1;
        alias ls="ls --color=auto";
    }

# gnome-terminal and mate-terminal don't set the TERM variable to xterm-256color,
#   though they do support 256 colors. we can check the COLORTERM variable to
#   see if we're in one of those terminals and set TERM accordingly
#   (Note that COLORTERM is only set in gnome-terminal versions < 3.13. after
#   that, VTE_VERSION is what should be relied on. but starting with VTE
#   version 0.40, TERM is set to xterm256-color by default, so this becomes
#   a non-issue at that point)
case "$COLORTERM" in
    "gnome-terminal" | "mate-terminal")
        if [ "$TERM" = "xterm" ]; then
            export TERM=xterm-256color
        fi
esac

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

# function to avoid adding duplicate entries to the variable given in $1
#   e.g.
#     varmunge PATH ~/bin after
varmunge () {
    case ":${!1}:" in
        *:"$2":*)
            ;;
        *)
            if [ "$3" = "after" ] ; then
                eval "${1}=\$${1}:$2"
            else
                eval "${1}=$2:\$${1}"
            fi
    esac
}

# source site-specific rc file, if it exists and is readable
if [ -r ~/.bashrc-site ]
then
    source ~/.bashrc-site
fi

unset varmunge

