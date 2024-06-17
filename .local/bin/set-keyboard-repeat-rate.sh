#! /usr/bin/env bash
# vim: set filetype=bash :

delay=200
rate=35

set -e

if [[ -v "WAYLAND_DISPLAY" ]]; then
    # wayland

    if [[ "$XDG_CURRENT_DESKTOP" =~ "GNOME" ]]; then
        set -x
        gsettings set org.gnome.desktop.peripherals.keyboard repeat             true
        gsettings set org.gnome.desktop.peripherals.keyboard delay              "$delay"
        gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval    "$rate"
    else
        echo "Detected non-GNOME Wayland environment; need to figure out how to set this"
        exit 1
    fi
else
    # Xorg
    xset r rate "$delay" "$rate"
fi
