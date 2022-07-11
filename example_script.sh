#!/usr/bin/env bash
# example_script.sh

# Load functions from the script
source xdisplayinfo.sh

# This loads hashmap DISPLAY_INFO
xdisplayinfo::load

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
