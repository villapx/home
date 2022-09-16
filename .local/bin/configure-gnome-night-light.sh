#! /usr/bin/env bash

set -e

function set_night_light_key()
{
    gsettings set org.gnome.settings-daemon.plugins.color "$1" "$2"
}

set_night_light_key     night-light-enabled             true
set_night_light_key     night-light-schedule-automatic  false
set_night_light_key     night-light-schedule-from       0
set_night_light_key     night-light-schedule-to         24
set_night_light_key     night-light-temperature         5500
