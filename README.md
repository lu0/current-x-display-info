# X Display Info

Linux CLI utility to easily get information of the current display, the one the
mouse is hovered over, in systems using X server.

## Dependencies

Tested with the following dependencies, installed by default in most Linux
distributions using X:

- `bash`: `4`+
- `xdotool`: `3.20160805`+
- `xrandr`: `1.5.0`+
- `grep`: `3.4`+

## Installation

### Option A: Using `pip`

```sh
pip3 install xdisplayinfo
```

### Option B: Adding source script to `$PATH`

```sh
git clone https://github.com/lu0/current-x-display-info
cd current-x-display-info/src/scripts/
ln -srf xdisplayinfo ~/.local/bin/xdisplayinfo
```


## Usage

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
