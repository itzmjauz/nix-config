#!/bin/sh

# Abort on error
set -o errexit
set -o errtrace
set -o nounset

# Config
dzen_font="Source Code Pro Medium:size=12"

# Arguments 
keymap_text=$1
win_id=$2
bar_height=$3
delay=$4
bg_color=$5
pers_mode=1

n_lines=$(echo -e "${keymap_text}" | wc -l)

if [ "${pers_mode}" -eq 1 ]
then
    pers_flag=( -p )
    #event_flag="onstart=grabkeys,uncollapse;button3=exit;key_Escape=ungrabkeys,exit"
    event_flag="onstart=grabkeys,uncollapse;button3=exit;key_Super_L=ungrabkeys,exit;key_Escape=ungrabkeys,exit"
else
    event_flag="onstart=uncollapse"
fi

screen_size=$(xdpyinfo | awk '/dimensions:/ { print $2; exit }')
screen_width=$(echo "${screen_size}" | cut -f1 -dx)
screen_height=$(echo "${screen_size}" | cut -f2 -dx)

y_pos=$((screen_height - bar_height * (n_lines + 1) - bar_height - 280))

# DEBUG
#echo -e "${keymap_text}" > ~/tmp/keymap

if [ "${delay}" -gt 0 ]; then
    sleep "${delay}"
    # Check if xmonad is still writing to stdin
    lsof -ad0 -Ep "$$" | grep "xmonad"
fi

(echo -e "${keymap_text}"; cat) | dzen2 "${pers_flag[@]}" -bg "${bg_color}" -fn "${dzen_font}" -h "${bar_height}" -l "${n_lines}" -y "${y_pos}" -w "${screen_width}" -e "${event_flag}"
