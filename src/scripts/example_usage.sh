#!/usr/bin/env bash
# example_usage.sh

# Retrieve and show properties of the display
# using `xdisplayinfo --<property name>`
echo ""
echo "    ↓"
echo "    y     $(xdisplayinfo --name)"
echo "→ x ┌─────────────────────────────────────┐"
echo "    │             width                   │"
echo "    │                      ┌───────────┐  │"
echo "    │                      │           │  │"
echo "    │ height               │ window_id │  │"
echo "    │                      │           │  │"
echo "    │                      └───────────┘  │"
echo "    └─────────────────────────────────────┘"
echo "      Resolution: $(xdisplayinfo --resolution)"
echo ""

echo -e "width:\t\t $(xdisplayinfo --width)"
echo -e "height:\t\t $(xdisplayinfo --height)"
echo -e "x:\t\t $(xdisplayinfo --offset-x)"
echo -e "y:\t\t $(xdisplayinfo --offset-y)"
echo -e "window_id:\t $(xdisplayinfo --window-id)"
