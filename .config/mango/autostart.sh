#!/bin/bash

set +e
# obs
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots >/dev/null 2>&1
# notify
# swaync -c ~/.config/mango/swaync/config.json -s ~/.config/mango/swaync/style.css >/dev/null 2>&1 &
swaync &
# night light
# wlsunset -T 3501 -t 3500 >/dev/null 2>&1 &
# wallpaper
swaybg -i ~/Pictures/wallpapers/totoro-catppuccin.png >/dev/null 2>&1 &
# top bar
waybar -c ~/.config/mango/waybar/config -s ~/.config/mango/waybar/style.css >/dev/null 2>&1 &
# clipboard content manager
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
# Permission authentication
/usr/libexec/polkit-gnome-authentication-agent-1 >/dev/null 2>&1 &
