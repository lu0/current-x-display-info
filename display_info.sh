#!/usr/bin/env bash

#
# This script gets information of the current display,
# where "current display" is the display the mouse is hovered over.
#
# Can be used as a library by sourcing it from another script
# and accessing hashmap DISPLAY_INFO after running `display_info::load`
# or as a command after adding it to your $PATH.
#
# https://github.com/lu0/current-x-display-info
#

declare -A DISPLAY_INFO=;                declare -a INFO_SORTING=
DISPLAY_INFO["monitor_name"]="";        INFO_SORTING=("monitor_name")
DISPLAY_INFO["resolution"]="";          INFO_SORTING+=("resolution")
DISPLAY_INFO["x"]="";                   INFO_SORTING+=("x")
DISPLAY_INFO["y"]="";                   INFO_SORTING+=("y")
DISPLAY_INFO["width"]="";               INFO_SORTING+=("width")
DISPLAY_INFO["height"]="";              INFO_SORTING+=("height")
DISPLAY_INFO["window_id"]="";           INFO_SORTING+=("window_id")

# Shows hashmap DISPLAY_INFO in the order specified by array INFO_SORTING
display_info::_print_porcelain() {
    echo >&2 -e "DISPLAY_INFO (porcelain):\n"
    for i in "${INFO_SORTING[@]}"; do
        echo "${DISPLAY_INFO[${i}]}"
    done
}

# Fills hashmap DISPLAY_INFO
display_info::load() {
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
    DISPLAY_INFO[window_id]="${WINDOW}"

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
            DISPLAY_INFO[monitor_name]="${monitor_names_array[monitor_index]}"
            DISPLAY_INFO[resolution]="${res_x}x${res_y}"

            DISPLAY_INFO[width]="${res_x}"
            DISPLAY_INFO[height]="${res_y}"
            DISPLAY_INFO[x]="${off_x}"
            DISPLAY_INFO[y]="${off_y}"
            break
        fi

        (( monitor_index++ ))
    done
}

display_info::_show_property() {

    case $# in
        0) display_info::_print_porcelain; return ;;
        *) ;;
    esac

    while getopts h-: OPT; do
        case "$OPT$OPTARG" in
            h | -help)      display_info::_show_usage ;;
            -name)          echo "${DISPLAY_INFO[monitor_name]}" ;;
            -resolution)    echo "${DISPLAY_INFO[resolution]}" ;;
            -offset-x)      echo "${DISPLAY_INFO[x]}" ;;
            -offset-y)      echo "${DISPLAY_INFO[y]}" ;;
            -width)         echo "${DISPLAY_INFO[width]}" ;;
            -height)        echo "${DISPLAY_INFO[height]}" ;;
            -window)     echo "${DISPLAY_INFO[window_id]}" ;;
            -all)
                echo -e "name:\t\t ${DISPLAY_INFO[monitor_name]}"
                echo -e "resolution:\t ${DISPLAY_INFO[resolution]}"
                echo -e "width:\t\t ${DISPLAY_INFO[width]}"
                echo -e "height:\t\t ${DISPLAY_INFO[height]}"
                echo -e "offset-x:\t ${DISPLAY_INFO[x]}"
                echo -e "offset-y:\t ${DISPLAY_INFO[y]}"
                echo -e "window-id:\t ${DISPLAY_INFO[window_id]}"
                ;;
            ??* | ?*)
                echo >&2 "illegal option: ${OPTARG}"
                display_info::_show_usage
                exit 1 ;;
        esac
        return
    done

    echo >&2 "illegal argument: $*"
    display_info::_show_usage
}

display_info::_show_usage() {
        echo -e "\nGet information of the current display on systems using X."
        echo -e "\nUSAGE:"
        echo -e "   display_info   [OPTIONS]"
        echo -e "   display_info   # Porcelain (line-parseable output)"
        echo -e "\nOPTIONS:"
        echo -e "   -h | --help        Show this manual."
        echo -e "        --name        Name of the current display."
        echo -e "        --resolution  Resolution."
        echo -e "        --offset-x    X coordinate of the top-left corner."
        echo -e "        --offset-y    Y coordinate of the top-left corner."
        echo -e "        --width       Width (resolution along the X axis)."
        echo -e "        --height      Height (resolution along the Y axis)."
        echo -e "        --window      ID of the active window (decimal)."
        echo -e "        --all         All previous properties.\n"
}

if [[ "${#BASH_SOURCE[@]}" -eq 1 ]]; then
    display_info::load
    display_info::_show_property "$@"
fi
