#! /usr/bin/env bash

set -e

profiles_list_schema='org.gnome.Terminal.ProfilesList'
profiles_list_key='list'

profiles=$(gsettings get ${profiles_list_schema} ${profiles_list_key})

profile_uuid='aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'

# does my profile exist?
if [[ "$profiles" != *"'${profile_uuid}'"* ]]; then
    echo "Profile $profile_uuid does not yet exist. Creating..."
    gsettings set "$profiles_list_schema" "$profiles_list_key" "${profiles%]*}, '$profile_uuid']"
    echo "Created profile $profile_uuid"
else
    echo "Profile $profile_uuid exists"
fi

function set_key()
{
    local schema="$1"
    local key="$2"
    local value="$3"

    cmd="gsettings set \"$schema\" \"$key\" \"$value\""
    echo $cmd
    eval $cmd
}

# set my profile as the default
set_key "$profiles_list_schema" 'default' "'$profile_uuid'"

# set GNOME Terminal keys
gnome_terminal_settings_schema='org.gnome.Terminal.Legacy.Settings'
set_key "$gnome_terminal_settings_schema" 'default-show-menubar' 'false'

# parse the colors from Xresources
colorscheme_file=~/.Xresources.d/colorschemes/jvilla_solid

function get_color()
{
    local color_name="$1"

    local color_value=$(grep "${color_name}:" "$colorscheme_file" | awk '{print $2}')

    # color_value looks like 'rgb:b6/ca/b6', need to convert it to 'rgb(182,202,182)'
    local octet1=${color_value:4:2}
    local octet2=${color_value:7:2}
    local octet3=${color_value:10:2}
    local ret="rgb($(( 16#$octet1 )),$(( 16#$octet2 )),$(( 16#$octet3 )))"

    echo "$ret"
}

color_foreground=$(get_color foreground)
color_background=$(get_color background)
color_cursor=$(get_color cursorColor)
color_bold=$(get_color colorBD)
color0=$(get_color color0)
color1=$(get_color color1)
color2=$(get_color color2)
color3=$(get_color color3)
color4=$(get_color color4)
color5=$(get_color color5)
color6=$(get_color color6)
color7=$(get_color color7)
color8=$(get_color color8)
color9=$(get_color color9)
color10=$(get_color color10)
color11=$(get_color color11)
color12=$(get_color color12)
color13=$(get_color color13)
color14=$(get_color color14)
color15=$(get_color color15)


# set all of the keys for my profile
profile_schema="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile_uuid}/"

set_key "$profile_schema" 'allow-bold'                      "true"
set_key "$profile_schema" 'audible-bell'                    "false"
set_key "$profile_schema" 'background-color'                "'$color_background'"
set_key "$profile_schema" 'background-transparency-percent' "0"
set_key "$profile_schema" 'backspace-binding'               "'ascii-delete'"
set_key "$profile_schema" 'bold-color'                      "'$color_bold'"
set_key "$profile_schema" 'bold-color-same-as-fg'           "false"
set_key "$profile_schema" 'bold-is-bright'                  "true"
set_key "$profile_schema" 'cursor-background-color'         "'$color_cursor'"
set_key "$profile_schema" 'cursor-blink-mode'               "'off'"
set_key "$profile_schema" 'cursor-colors-set'               "true"
set_key "$profile_schema" 'cursor-foreground-color'         "'$color_background'"
set_key "$profile_schema" 'cursor-shape'                    "'block'"
set_key "$profile_schema" 'custom-command'                  "''"
set_key "$profile_schema" 'default-show-menubar'            "false"
set_key "$profile_schema" 'delete-binding'                  "'delete-sequence'"
set_key "$profile_schema" 'encoding'                        "'UTF-8'"
set_key "$profile_schema" 'font'                            "'Bitstream Vera Sans Mono 11'"
set_key "$profile_schema" 'foreground-color'                "'$color_foreground'"
set_key "$profile_schema" 'highlight-colors-set'            "false"
set_key "$profile_schema" 'login-shell'                     "false"
set_key "$profile_schema" 'palette'                         "['$color0', '$color1', '$color2', '$color3', '$color4', '$color5', '$color6', '$color7', '$color8', '$color9', '$color10', '$color11', '$color12', '$color13', '$color14', '$color15']"
set_key "$profile_schema" 'rewrap-on-resize'                "true"
set_key "$profile_schema" 'scrollback-unlimited'            "true"
set_key "$profile_schema" 'scrollbar-policy'                "'never'"
set_key "$profile_schema" 'scroll-on-keystroke'             "true"
set_key "$profile_schema" 'scroll-on-output'                "false"
set_key "$profile_schema" 'text-blink-mode'                 "'always'"
set_key "$profile_schema" 'use-custom-command'              "false"
set_key "$profile_schema" 'use-system-font'                 "false"
set_key "$profile_schema" 'use-theme-colors'                "false"
set_key "$profile_schema" 'use-theme-transparency'          "false"
set_key "$profile_schema" 'use-transparent-background'      "false"
set_key "$profile_schema" 'visible-name'                    "'$(whoami)'"
