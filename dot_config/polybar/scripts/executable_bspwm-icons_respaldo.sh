#!/bin/bash

# Define iconos para cada aplicación
declare -A icons
icons=( 
    ["firefox"]="" 
    ["navigator"]=""  
    ["firefox-esr"]=""
    ["brave"]=""
    ["chromium"]=""
    ["chromium-browser"]=""
    ["alacritty"]=""
    ["kitty"]=""
    ["thunar"]=""
    ["spacefm"]=""
    ["pcmanfm"]=""
    ["nemo"]=""
    ["geany"]=""
    ["vscode"]=""
    ["code"]=""
    ["deadbeef"]=""    
    ["cantata"]=""    
    ["sigil"]=""
    ["smplayer"]=""    
    ["vlc"]=""
    ["mpv"]=""
    ["calibre"]=""
    ["discord"]=""
    ["telegram"]=""
    ["steam"]=""
    ["spotify"]=""
    ["gimp"]=""
)

# Icono para escritorios vacíos
empty_icon=""

# Separador entre iconos
separator="  "

# Colores
color_activo="#f8f8f2"     # Rosa para escritorio activo
color_inactivo="#717593"    # Morado claro  para escritorios sin apps abiertas
color_con_apps="#C2A4F5"     # Gris claro/Blanco para escritorios con apps abiertas

bspc subscribe report | while read -r line; do
    output=""
    active_desktop=$(bspc query -D -d focused --names)

    for desktop in $(bspc query -D --names); do
        windows=$(bspc query -N -d "$desktop")

        if [[ -n "$windows" ]]; then
            # Obtener la última aplicación abierta en este escritorio
            last_window=$(echo "$windows" | tail -n 1)
            class=$(xprop -id "$last_window" WM_CLASS | awk -F '"' '{print $4}' | tr '[:upper:]' '[:lower:]')
            icon="${icons[$class]:-$empty_icon}"
        else
            icon="$empty_icon"
        fi

        # Aplicar separación entre iconos
        icon=" $icon $separator"

        # Definir color según estado del escritorio
        if [[ "$desktop" == "$active_desktop" ]]; then
            output+="%{A:bspc desktop -f $desktop:}%{F$color_activo}$icon%{F-}%{A}"
        elif [[ -n "$windows" ]]; then
            output+="%{A:bspc desktop -f $desktop:}%{F$color_con_apps}$icon%{F-}%{A}"
        else
            output+="%{A:bspc desktop -f $desktop:}%{F$color_inactivo}$icon%{F-}%{A}"
        fi
    done

    echo "%{l}$output"
done

