#!/bin/bash

get_connected_monitors() {
    # Get the list of connected monitors using gdbus
    output=$(gdbus call --session --dest org.gnome.Mutter.DisplayConfig --object-path /org/gnome/Mutter/DisplayConfig --method org.gnome.Mutter.DisplayConfig.GetResources)

    echo $(echo $output | grep -o 'vendor' | wc -l)
}

while true; do
  sleep 10
  echo "Checking monitor status"

  if [ $(get_connected_monitors) -gt 1 ]; then
    # Multi monitor setup
    gnome-extensions disable dash-to-dock@micxgx.gmail.com
    gnome-extensions enable dash-to-panel@jderose9.github.com
    gnome-extensions enable arcmenu@arcmenu.com
  else
    # Single monitor setup
    gnome-extensions disable dash-to-panel@jderose9.github.com
    gnome-extensions disable arcmenu@arcmenu.com
    gnome-extensions enable dash-to-dock@micxgx.gmail.com
  fi
done