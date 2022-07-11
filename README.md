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

### As a lightweight module in another Bash script

Load the `xdisplayinfo` script in the target script, i.e:

```bash
#!/usr/bin/env bash
# example_script.sh

# Load functions from the script
source xdisplayinfo.sh
```

Retrieve properties of the display by using `xdisplayinfo::<property name>`, i.e:

```bash
echo ""
echo "    ↓"
echo "    y     $(xdisplayinfo::name)"
echo "→ x ┌─────────────────────────────────────┐"
echo "    │             width                   │"
echo "    │                      ┌───────────┐  │"
echo "    │                      │           │  │"
echo "    │ height               │ window_id │  │"
echo "    │                      │           │  │"
echo "    │                      └───────────┘  │"
echo "    └─────────────────────────────────────┘"
echo "      Resolution: $(xdisplayinfo::resolution)"
echo ""

echo -e "width:\t\t $(xdisplayinfo::width)"
echo -e "height:\t\t $(xdisplayinfo::height)"
echo -e "x:\t\t $(xdisplayinfo::offset-x)"
echo -e "y:\t\t $(xdisplayinfo::offset-y)"
echo -e "window_id:\t $(xdisplayinfo::window-id)"

```

Run the provided example:
```bash
$ ./example_script.sh
```

![example output](assets/example_script_output.png)


### As a command

Link the script to your `PATH` as `xdisplayinfo`:

```sh
ln -srf xdisplayinfo.sh ~/.local/bin/xdisplayinfo
```

Run `xdisplayinfo --help` to see the list of available options.

```txt
Get information of the current display on systems using X.

USAGE:
   xdisplayinfo   [OPTIONS]

OPTIONS:
   --name        Name of the current display.
   --resolution  Resolution.
   --offset-x    X coordinate of the top-left corner.
   --offset-y    Y coordinate of the top-left corner.
   --width       Width (resolution along the X axis).
   --height      Height (resolution along the Y axis).
   --window-id   ID of the active window (decimal).
   --all         All previous properties.
```
