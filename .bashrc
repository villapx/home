# vim: set filetype=bash :

# aliases
alias awkremovedups="awk '!seen[\$0]++'"
alias cp="cp -i"
alias datetime="date +%Y-%m-%d_%H%M%S"
alias gitlogquick="git log --pretty='format:%C(auto)%h %C(magenta)%as%C(auto)%d %s' --decorate --graph -n15"
alias gitupdaterpo="git pull && git submodule update --recursive && git remote prune origin && git submodule foreach --recursive 'git remote prune origin'"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias diff="diff --color=auto"
alias makeprinttargets="make -qp | awk -F: '/^[a-zA-Z0-9][^\$#\\/\\t=]*:([^=]|$)/ {split(\$1,A,/ /);for(i in A)print A[i]}' | sort -u"
alias mv="mv -i"
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


# all about command completion
BC=/usr/share/bash-completion/bash_completion
if [[ -r "$BC" ]]; then
    source "$BC"
fi

command -v hatch &>/dev/null && source <(_HATCH_COMPLETE=bash_source hatch)
command -v helm &>/dev/null && source <(helm completion bash)
command -v kubectl &>/dev/null && source <(kubectl completion bash)
command -v pipx &>/dev/null && command -v register-python-argcomplete &>/dev/null && eval "$(register-python-argcomplete pipx)"
command -v terraform &>/dev/null && complete -C "$(which terraform)" terraform
command -v thefuck &>/dev/null && eval "$(thefuck --alias)"
command -v uv &>/dev/null && eval "$(uv generate-shell-completion bash)"

# make 'less' more friendly for non-text input files.
#   first, see if lesspipe is available (usually found on Ubuntu variants).
if [[ -x /usr/bin/lesspipe ]]; then
    eval "$(SHELL=/bin/sh lesspipe)"

# otherwise look for lesspipe.sh (often found on RHEL and derivatives)
elif [[ -x /usr/bin/lesspipe.sh ]]; then
    export LESSOPEN="|/usr/bin/lesspipe.sh %s"
fi


# enable color support for ls if it's available
command -v dircolors &>/dev/null &&
    {
        eval "$(dircolors | sed -E 's_:ow=[0-9;]+:_:ow=01;07;34:_')"
        alias ls="ls --color=auto"
    }


# make the 'gpg' command use the TTY for password input
export GPG_TTY="$(tty)"


# set prompt
if [[ -n "$TERM" ]]; then
    ncolors="$(tput colors)"
    if [[ -n "$ncolors" ]] && [[ "$ncolors" -ge 8 ]]; then
        bold="$(tput bold)"
        italic="$(tput sitm)"
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

    # helper function to print out the colors and accents to test terminal features
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

        echo "${italic}"            "italic"        "${normal}"
        echo "${bold}"              "bold"          "${normal}"
        echo "${standout}"          "standout"      "${normal}"
        echo "${underline}"         "underline"     "${normal}"
        echo "${italic}${bold}"     "italic bold"   "${normal}"
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


# function for "update all"
function upd()
{
    local post_command=":"
    if [[ "$1" == "r" ]] || [[ "$1" == "reboot" ]]; then
        post_command="sudo reboot"
    elif [[ "$1" == "p" ]] || [[ "$1" == "poweroff" ]]; then
        post_command="sudo poweroff"
    elif [[ -n "$1" ]]; then
        echo "Usage: upd [r|reboot|p|poweroff]"
        return 255
    fi

    local update_cmd
    if [[ -n "$(command -v apt)" ]]; then
        update_cmd="sudo bash -c 'apt update && apt -y dist-upgrade && apt -y autoremove'"
    elif [[ -n "$(command -v yay)" ]]; then
        update_cmd="yay"
    elif [[ -n "$(command -v pacman)" ]]; then
        update_cmd="sudo pacman -Syu"
    else
        echo "Detected an unsupported system. Add support for this system's package manager"
        return 1
    fi

    if [[ -n "$(command -v snap)" ]]; then
        update_cmd+=" && sudo snap refresh"
    fi

    if [[ -n "$(command -v pipx)" ]]; then
        update_cmd+=" && pipx upgrade-all"
    fi

    cmd="${update_cmd} && ${post_command}"
    echo "$cmd"
    eval "$cmd"
}


# function to create an SSH alias, an SFTP alias and SCP download and upload functions for an
#   SSH server
# args:
#   $1: name you'd like to give to the server, a.k.a. the "site name"
#   $2: IP address or hostname of the server
#   $3: username you'll log in as
#   $4: SSH port of the server
#
# Example usage:
#   site_setup my_pc 192.168.0.5 myusername 22
#
# That creates the following:
#   - The alias 'my_pc', which aliases to the command to SSH into the server
#   - The function 'my_pc_portfwd()', which allows you to easily SSH into the server and specify
#     ports to forward
#   - The alias 'my_pc_sftp', which aliases to the command to log in to the SFTP shell on the server
#   - The function 'my_pc_dl()', which allows you to easily download files from the server via SCP
#   - The function 'my_pc_ul()', which allows you to easily upload files to the server via SCP.
function site_setup()
{
    # create the site_ip, site_uname and site_port variables
    eval "${1}_ip=\"$2\""
    eval "${1}_uname=\"$3\""
    eval "${1}_port=$4"

    # create the site SSH alias, which is just the site name
    eval "alias $1=\"ssh -p\$${1}_port \$${1}_uname@\$${1}_ip\""

    # create the SSH-with-port-forwards alias
    eval "function ${1}_portfwd() { ssh_with_port_forwards $1 \"\$@\"; }"

    # create the site SFTP alias, which will be called site_sftp
    eval "alias ${1}_sftp=\"sftp -oPort=\$${1}_port \$${1}_uname@\$${1}_ip\""

    # create the SCP download function, which will be called site_dl()
    eval "function ${1}_dl() { scp_download $1 \"\$@\"; }"

    # create the SCP upload function, which will be called site_ul()
    eval "function ${1}_ul() { scp_upload $1 \"\$@\"; }"
}

# function for SSHing into the site, with -L/localhost port forwards
#   - first arg: site name
#   - remaining args:
#     if the arg is an integer: add `-L<arg>:localhost:<arg>` to the SSH command
#     else: add the arg as-is to the SSH command
function ssh_with_port_forwards()
{
    local site

    if [[ $1 ]]; then site="$1"; else echo "you're doing it wrong"; return; fi

    local cmd=("${site}")

    while [[ "$2" ]]; do
        if [[ "$2" =~ ^[0-9]+$ ]]; then
            cmd+=("-L${2}:localhost:${2}")
            shift
        else
            cmd+=("$2")
            shift
        fi
    done

    eval "${cmd[@]}"
}

# function for downloading via SCP
#   - first arg: site name
#   - second through $#-1: remote paths to download
#   - final arg: destination arg for scp command
function scp_download()
{
    local site

    if [[ $1 ]]; then site="$1"; else echo "you're doing it wrong"; return; fi

    if [[ $# -lt 3 ]]; then
        echo "Usage: ${site}_dl remote_path [remote_path ...] dest"
        return
    fi

    local cmd="scp -oPort=\$${site}_port"

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

    local cmd="scp -oPort=\$${site}_port"

    for path in "${@:2:$#-2}"; do
        cmd+=" \"$path\""
    done

    eval "$cmd \$${site}_uname@\$${site}_ip:\"${@:$#}\""
}


# source site-specific rc file, if it exists and is readable
if [[ -r ~/.bashrc-site ]]; then
    source ~/.bashrc-site
fi
