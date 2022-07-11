# Current X-Display Info

This repository provides an utility script to get information of the current
display, the one the mouse is over, and use it as a module in other scripts by
sourcing it.

- [Current X-Display Info](#current-x-display-info)
  - [Dependencies](#dependencies)
  - [Usage](#usage)
    - [As a module in another script](#as-a-module-in-another-script)
    - [As a command](#as-a-command)

## Dependencies

This script was tested with the following dependencies, which are installed by
default in most distributions using X:

- `bash` `5`
- `xdotool` `3.20160805`+
- `xrandr` `1.5.0`+
- `grep` `3.4`+

## Usage

### As a module in another script

Minimal example:

```bash
#!/usr/bin/env bash
# example_script.sh

# Load functions from the script
source display_info.sh

# This loads hashmap DISPLAY_INFO
display_info::load

# Use the hashmap
echo ""
echo "    ↓"
echo "    y     ${DISPLAY_INFO[monitor_name]}"
echo "→ x ┌─────────────────────────────────────┐"
echo "    │             width                   │"
echo "    │                      ┌───────────┐  │"
echo "    │                      │           │  │"
echo "    │ height               │ window_id │  │"
echo "    │                      │           │  │"
echo "    │                      └───────────┘  │"
echo "    └─────────────────────────────────────┘"
echo "      Resolution: ${DISPLAY_INFO[resolution]}"
echo ""

echo -e "width:\t\t ${DISPLAY_INFO[width]}"
echo -e "height:\t\t ${DISPLAY_INFO[height]}"
echo -e "x:\t\t ${DISPLAY_INFO[x]}"
echo -e "y:\t\t ${DISPLAY_INFO[y]}"
echo -e "window_id:\t ${DISPLAY_INFO[window_id]}"

```

```bash
$ ./example.sh
```

![example output](assets/example_script_output.png)


### As a command

Link the script to your `PATH` as `display_info`

```sh
ln -srf display_info.sh ~/.local/bin/display_info
```

Run `display_info -h` to see the list of available options.

```txt
Get information of the current display on systems using X.

USAGE:
   display_info   [OPTIONS]
   display_info   # Porcelain (line-parseable output)

OPTIONS:
   -h | --help        Show this manual.
        --name        Name of the current display.
        --resolution  Resolution.
        --offset-x    X coordinate of the top-left corner.
        --offset-y    Y coordinate of the top-left corner.
        --width       Width (resolution along the X axis).
        --height      Height (resolution along the Y axis).
        --window      ID of the active window (decimal).
        --all         All previous properties.
```

*Note*: Message "`DISPLAY_INFO (porcelain):`" received when no options are passed is only for debugging purposes, it won't pollute the output if you intend to use it as it is. You can can actually do:

```bash
$ info=$(display_info)
$ name=$(echo $info | cut -d' ' -f1)
$ height=$(echo $info | cut -d' ' -f6)
$ echo "name: ${name}, height: ${height}"

name: HDMI-1, height: 1440
```
