#! /usr/bin/env bash

#
# These are the settings I needed to change for configuring the out-of-the-box GNOME dock in Ubuntu
# 20.04 (GNOME 3.36). Things may be different in other versions of GNOME or Ubuntu.
#

set -e

function set_dock_key()
{
    gsettings set org.gnome.shell.extensions.dash-to-dock "$1" "$2"
}

# dock hovers over your windows rather than always taking up a portion of the screen
set_dock_key    dock-fixed              false

set_dock_key    dock-position           BOTTOM

# imagine the dock is vertical along the left side of the screen; this makes it so the dock only
# extends along the total height of the icons, not the entire height of the screen
set_dock_key    extend-height           false

set_dock_key    show-show-apps-button   false

# show on all monitors
set_dock_key    multi-monitor           true
