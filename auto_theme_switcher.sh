#!/bin/bash

# Setze die Koordinaten deines Standorts mit N/S und E/W
LATITUDE="LAT"
LONGITUDE="LONG"

# Set your preferred times here (24-hour format)
SUN_DATA=$(sunwait -p $LATITUDE $LONGITUDE)
DAY_THEME_HOUR=$(echo "$SUN_DATA" | grep "Sun rises" | awk '{print substr($3, 2,1)}')     # Time to switch to light theme (e.g., 6 for 6:00 AM)
DAY_THEME_MINUTE=$(echo "$SUN_DATA" | grep "Sun rises" | awk '{print substr($3, 3,2)}' | sed 's/^0*//')    # Minutes for light theme switch, removing leading zeros
NIGHT_THEME_HOUR=$(echo "$SUN_DATA" | grep "Sun rises" | awk '{print substr($6, 1,2)}')   # Time to switch to dark theme (e.g., 17 for 5:00 PM)
NIGHT_THEME_MINUTE=$(echo "$SUN_DATA" | grep "Sun rises" | awk '{print substr($6, 3,2)}' | sed 's/^0*//') # Minutes for dark theme switch, removing leading zeros

# Set your preferred themes
# Light theme settings
#LIGHT_GTK_THEME="Yaru"          # Your preferred light GTK theme
#LIGHT_ICON_THEME="Yaru"         # Your preferred light icon theme
LIGHT_COLOR_SCHEME="prefer-light"

# Dark theme settings
#DARK_GTK_THEME="Yaru-dark"      # Your preferred dark GTK theme
#DARK_ICON_THEME="Yaru-dark"     # Your preferred dark icon theme
DARK_COLOR_SCHEME="prefer-dark"

DAY_THEME_TIME=$((DAY_THEME_HOUR * 60 + DAY_THEME_MINUTE))
NIGHT_THEME_TIME=$((NIGHT_THEME_HOUR * 60 + NIGHT_THEME_MINUTE))

# Error logging file location
log_file="$HOME/.config/autostart-scripts/logs/auto_theme_switcher.log"
exec 2> >(while read -r line; do echo "$(date): $line" >> "$log_file"; done)

set_light_theme() {
    #gsettings set org.gnome.desktop.interface gtk-theme "$LIGHT_GTK_THEME"
    #gsettings set org.gnome.desktop.interface icon-theme "$LIGHT_ICON_THEME"
    gsettings set org.gnome.desktop.interface color-scheme "$LIGHT_COLOR_SCHEME"
}

set_dark_theme() {
    #gsettings set org.gnome.desktop.interface gtk-theme "$DARK_GTK_THEME"
    #gsettings set org.gnome.desktop.interface icon-theme "$DARK_ICON_THEME"
    gsettings set org.gnome.desktop.interface color-scheme "$DARK_COLOR_SCHEME"
}

check_time() {
    current_hour=$(date +%-H)
    current_minute=$(date +%-M)
    time_in_minutes=$((10#$current_hour * 60 + 10#$current_minute))

    if [ $time_in_minutes -ge $DAY_THEME_TIME ] && [ $time_in_minutes -lt $NIGHT_THEME_TIME ]; then
        set_light_theme
    else
        set_dark_theme
    fi
}

check_time

(
    dbus-monitor --system "type='signal',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'" 2>/dev/null | \
    while read -r line; do
        if echo "$line" | grep -q "false"; then
            sleep 2
            check_time
        fi
    done
) &

while true; do
    current_hour=$(date +%-H)
    current_minute=$(date +%-M)
    
    if [ "$current_hour" = "$DAY_THEME_HOUR" ] && [ "$current_minute" = "$DAY_THEME_MINUTE" ]; then
        set_light_theme
    elif [ "$current_hour" = "$NIGHT_THEME_HOUR" ] && [ "$current_minute" = "$NIGHT_THEME_MINUTE" ]; then
        set_dark_theme
    fi
    
    sleep 30
done
