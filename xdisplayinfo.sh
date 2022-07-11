#!/usr/bin/env bash

#
# This script gets information of the current display,
# where "current display" is the display the mouse is hovered over.
#
# Can be used as Bash library by sourcing it from another script
# and accessing its properties by using `xdisplayinfo::<property name>`,
# or as a command (after adding it to your $PATH).
#
# https://github.com/lu0/current-x-display-info
#

declare -A _PROPERTIES=(
    ["name"]=""
    ["resolution"]=""
    ["offset-x"]=""
    ["offset-y"]=""
    ["width"]=""
    ["height"]=""
    ["window-id"]=""
)


# Fills hashmap _PROPERTIES
xdisplayinfo::__reload() {
    # Regex to match all contiguous numbers
    nums_re="[0-9]+"

    # Regex to match lines [xres]x[yres]+[xoffset]+[yoffset]
    dimensions_re="^${nums_re}x${nums_re}\+${nums_re}\+${nums_re}$"
    #            │          │           │   match end of line ─┘
    #            │          │           └ + scaped (offset separator)
    #            │          └─ x (resolution separator)
    #            └─ match start of line

    # Evaluates to variables X, Y, SCREEN, WINDOW
    eval "$(xdotool getmouselocation --shell)"
    _PROPERTIES[window-id]="${WINDOW}"

    # `xrandr --current` is faster than plain `xrandr` since
    # it doesn't re-evaluate for hardware changes
    connected_displays=$(xrandr --current | grep -w connected)

    # shellcheck disable=2207 # Command unquoted to enable array splitting
    monitor_names_array=( $(echo "${connected_displays}" | cut -d' ' -f1) )

    props_split_as_lines="$(echo "${connected_displays}" | tr -s ' ' '\n')"
    dimension_rows=$(echo -e "${props_split_as_lines}" | grep -Po "${dimensions_re}")

    monitor_index=0
    for dim in ${dimension_rows}; do
        # shellcheck disable=2207 # Command unquoted to enable splitting
        dimension_cols_array=( $(echo "${dim}" | grep -Po "${nums_re}") )

        res_x="${dimension_cols_array[0]}"
        res_y="${dimension_cols_array[1]}"
        off_x="${dimension_cols_array[2]}"
        off_y="${dimension_cols_array[3]}"

        if [ "${X}" -ge "${off_x}" ] && [ "${X}" -lt "$(( off_x + res_x ))" ] && \
           [ "${Y}" -ge "${off_y}" ] && [ "${Y}" -lt "$(( off_y + res_y ))" ];
        then
            _PROPERTIES[name]="${monitor_names_array[monitor_index]}"
            _PROPERTIES[resolution]="${res_x}x${res_y}"

            _PROPERTIES[width]="${res_x}"
            _PROPERTIES[height]="${res_y}"
            _PROPERTIES[offset-x]="${off_x}"
            _PROPERTIES[offset-y]="${off_y}"
            break
        fi

        (( monitor_index++ ))
    done
}

xdisplayinfo::name() {
    xdisplayinfo::__reload
    echo "${_PROPERTIES[name]}"
}

xdisplayinfo::resolution() {
    xdisplayinfo::__reload
    echo "${_PROPERTIES[resolution]}"
}

xdisplayinfo::offset-x() {
    xdisplayinfo::__reload
    echo "${_PROPERTIES[offset-x]}"
}

xdisplayinfo::offset-y() {
    xdisplayinfo::__reload
    echo "${_PROPERTIES[offset-y]}"
}

xdisplayinfo::width() {
    xdisplayinfo::__reload
    echo "${_PROPERTIES[width]}"
}

xdisplayinfo::height() {
    xdisplayinfo::__reload
    echo "${_PROPERTIES[height]}"
}

xdisplayinfo::window-id() {
    xdisplayinfo::__reload
    echo "${_PROPERTIES[window-id]}"
}

xdisplayinfo::__parse_cli_options() {

    while getopts h-: OPT; do
        readonly long_option="$OPT$OPTARG"
        case $long_option in
            -all)
                xdisplayinfo::__reload
                echo -e "name:\t\t ${_PROPERTIES[name]}"
                echo -e "resolution:\t ${_PROPERTIES[resolution]}"
                echo -e "width:\t\t ${_PROPERTIES[width]}"
                echo -e "height:\t\t ${_PROPERTIES[height]}"
                echo -e "offset-x:\t ${_PROPERTIES[offset-x]}"
                echo -e "offset-y:\t ${_PROPERTIES[offset-y]}"
                echo -e "window-id:\t ${_PROPERTIES[window-id]}"
                exit 0
                ;;
            *)
                property_name="${long_option##-}"
                xdisplayinfo::"$property_name" 2>/dev/null && exit 0
                xdisplayinfo::_show_usage && exit 1
                ;;
        esac
    done

    xdisplayinfo::_show_usage && exit 1
}

xdisplayinfo::_show_usage() {
        echo -e "\nGet information of the current display on systems using X."
        echo -e "\nUSAGE:"
        echo -e "   xdisplayinfo   [OPTIONS]"
        echo -e "\nOPTIONS:"
        echo -e "   --name        Name of the current display."
        echo -e "   --resolution  Resolution."
        echo -e "   --offset-x    X coordinate of the top-left corner."
        echo -e "   --offset-y    Y coordinate of the top-left corner."
        echo -e "   --width       Width (resolution along the X axis)."
        echo -e "   --height      Height (resolution along the Y axis)."
        echo -e "   --window-id   ID of the active window (decimal)."
        echo -e "   --all         All previous properties.\n"
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
    xdisplayinfo::__parse_cli_options "$@"
fi
