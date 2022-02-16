# aliases
alias awkremovedups="awk '!seen[\$0]++'"
alias cp="cp -i"
alias datetime="date +%Y-%m-%d_%H%M%S"
alias gitlogquick="git log --oneline --decorate -n15"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias la="ls -la"
alias makeprinttargets="make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split(\$1,A,/ /);for(i in A)print A[i]}' | sort -u"
alias mv="mv -i"
alias psef="ps -ef"
alias rm="rm -i"
alias valg="valgrind --tool=memcheck --leak-check=full --show-reachable=yes"

HISTCONTROL=ignoreboth
if [[ ${BASH_VERSINFO[0]} -gt 4 || (${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -ge 3) ]]
then
    HISTSIZE=-1
else
    HISTSIZE=
    HISTFILESIZE=
fi

# make 'less' more friendly for non-text input files.
#   first, see if lesspipe is available (usually found on Ubuntu variants).
if [[ -x /usr/bin/lesspipe ]]
then
    eval "$(SHELL=/bin/sh lesspipe)"

# otherwise look for lesspipe.sh (often found on RHEL and derivatives)
elif [[ -x /usr/bin/lesspipe.sh ]]
then
    export LESSOPEN="|/usr/bin/lesspipe.sh %s"
fi

# enable color support for ls if it's available
command -v dircolors >/dev/null 2>&1 &&
    {
        eval "$(dircolors | sed -E 's_:ow=[0-9;]+:_:ow=01;07;34:_')"
        alias ls="ls --color=auto"
    }

# make the 'gpg' command use the TTY for password input
export GPG_TTY=$(tty)

# gnome-terminal and mate-terminal don't set the TERM variable to xterm-256color,
#   though they do support 256 colors. we can check the COLORTERM variable to
#   see if we're in one of those terminals and set TERM accordingly
#   (Note that COLORTERM is only set in gnome-terminal versions < 3.13. after
#   that, VTE_VERSION is what should be relied on. but starting with VTE
#   version 0.40, TERM is set to xterm256-color by default, so this becomes
#   a non-issue at that point)
case "$COLORTERM" in
    "gnome-terminal" | "mate-terminal")
        if [[ "$TERM" = "xterm" ]]; then
            export TERM=xterm-256color
        fi
esac

# set prompt
if [[ $TERM ]]
then
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

    # helper function to print out the colors
    printcolors()
    {
        echo "${black}"             "black"         "${normal}"
        echo "${bold}${black}"      "black bold"    "${normal}"
        echo "${red}"               "red"           "${normal}"
        echo "${bold}${red}"        "red bold"      "${normal}"
        echo "${green}"             "green"         "${normal}"
        echo "${bold}${green}"      "green bold"    "${normal}"
        echo "${yellow}"            "yellow"        "${normal}"
        echo "${bold}${yellow}"     "yellow bold"   "${normal}"
        echo "${blue}"              "blue"          "${normal}"
        echo "${bold}${blue}"       "blue bold"     "${normal}"
        echo "${magenta}"           "magenta"       "${normal}"
        echo "${bold}${magenta}"    "magenta bold"  "${normal}"
        echo "${cyan}"              "cyan"          "${normal}"
        echo "${bold}${cyan}"       "cyan bold"     "${normal}"
        echo "${white}"             "white"         "${normal}"
        echo "${bold}${white}"      "white bold"    "${normal}"
    }
else
    printcolors() { echo "TERM not set"; }
fi
PS1="${incognito}\[${bold}${cyan}\][\A] \[${green}\]\u\[${normal}\]@\h:\w $ "

# function to go into an "incognito" shell, where no history is saved
incognito ()
{
    export incognito="\[${red}\][inc] \[${normal}\]"
    HISTFILE=/dev/null bash
}

# function to create an SSH alias, an SFTP alias and SCP download and upload
#   functions for an SSH server
# args:
#   $1: name you'd like to give to the server, a.k.a. the "site name"
#   $2: IP address or hostname of the server
#   $3: username you'll log in as
#   $4: SSH port of the server
#
# Example usage:
#   site_setup my_pc 192.168.0.5 myusername 22
#
# That creates the alias 'my_pc', which aliases to the command to SSH into
#   the server; the alias 'my_pc_sftp', which aliases to the command to log
#   in to the SFTP shell on the server; the function 'my_pc_dl()', which
#   allows you to easily download files from the server via SCP; and the
#   function 'my_pc_ul()', which allows you to easily upload files to the
#   server via SCP.
function site_setup()
{
    # create the site_ip, site_uname and site_port variables
    eval "${1}_ip=\"$2\""
    eval "${1}_uname=\"$3\""
    eval "${1}_port=$4"

    # create the site SSH alias, which is just the site name
    eval "alias $1=\"ssh -p\$${1}_port \$${1}_uname@\$${1}_ip\""

    # create the site SFTP alias, which will be called site_sftp
    eval "alias ${1}_sftp=\"sftp -oPort=\$${1}_port \$${1}_uname@\$${1}_ip\""

    # create the SCP download function, which will be called site_dl()
    eval "function ${1}_dl() { scp_download $1 \"\$@\"; }"

    # create the SCP upload function, which will be called site_ul()
    eval "function ${1}_ul() { scp_upload $1 \"\$@\"; }"
}

# function for downloading via SCP
#   - first arg: site name
#   - second through $#-1: remote paths to download
#   - final arg: destination arg for scp command
function scp_download()
{
    local site
    local cmd

    if [[ $1 ]]; then site="$1"; else echo "you're doing it wrong"; return; fi

    if [[ $# -lt 3 ]]; then
        echo "Usage: ${site}_dl remote_path [remote_path ...] dest"
        return
    fi

    cmd="scp -oPort=\$${site}_port"

    for path in "${@:2:$#-2}"; do
        cmd+=" \$${site}_uname@\$${site}_ip:\"$path\""
    done

    eval "$cmd \"${@:$#}\""
}

# function for uploading via SCP
#   - first arg: site name
#   - second through $#-1: local paths to upload
#   - last arg: remote path to save to
function scp_upload()
{
    local site

    if [[ $1 ]]; then site="$1"; else echo "you're doing it wrong"; return; fi

    if [[ $# -lt 3 ]]; then
        echo "Usage: ${site}_ul local_path [local_path ...] remote_path"
        return
    fi

    cmd="scp -oPort=\$${site}_port"

    for path in "${@:2:$#-2}"; do
        cmd+=" \"$path\""
    done

    eval "$cmd \$${site}_uname@\$${site}_ip:\"${@:$#}\""
}

# source site-specific rc file, if it exists and is readable
if [ -r ~/.bashrc-site ]
then
    source ~/.bashrc-site
fi

