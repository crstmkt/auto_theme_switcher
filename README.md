# Auto Theme Switcher for GNOME

## Description
Auto Theme Switcher is a bash script that automatically switches between light and dark themes in GNOME desktop environment based on user-defined time schedules. It provides a seamless transition between themes and supports custom GTK themes and icon sets.

## Features
- Automatic switching between light and dark themes at specified times
- Automatic theme adjustment after boot or system resume from sleep

## Prerequisites
- GNOME Desktop Environment
- `gsettings` (usually pre-installed with GNOME)
- `dbus-monitor` (usually pre-installed with GNOME)

## Installation

1. Create a bin directory in your home folder if it doesn't exist:

`mkdir -p ~/bin`

2. Download the script:

`wget -O ~/bin/auto_theme_switcher.sh https://raw.githubusercontent.com/glaicer/auto_theme_switcher/main/auto_theme_switcher.sh`

3. Make the script executable:

`chmod +x ~/bin/auto_theme_switcher.sh`

4. Edit the script to set your preferred times and themes:

`nano ~/bin/auto_theme_switcher.sh`

5. (Optional) You may want to set different wallpapers for light and dark themes. This could be done with:

`gsettings set org.gnome.desktop.background picture-uri '/path/to/light/wallpaper.png'`

`gsettings set org.gnome.desktop.background picture-uri-dark '/path/to/dark/wallpaper.png'`

## Configuration

### Time Settings
Modify these variables to set your preferred switching times (24-hour format):

`DAY_THEME_HOUR=6 # Hours to switch to light theme (do not start with zero)`

`DAY_THEME_MINUTE=0 # Minutes for light theme switch`

`NIGHT_THEME_HOUR=17 # Hours to switch to dark theme (do not start with zero)`

`NIGHT_THEME_MINUTE=30 # Minutes for dark theme switch`

### Theme Settings
Set your preferred themes (must be installed on your system):

`LIGHT_GTK_THEME="Yaru" # Your preferred light GTK theme` 

`LIGHT_ICON_THEME="Yaru" # Your preferred light icon theme`

`LIGHT_COLOR_SCHEME="prefer-light"`

`DARK_GTK_THEME="Yaru-dark" # Your preferred dark GTK theme`

`DARK_ICON_THEME="Yaru-dark" # Your preferred dark icon theme`

`DARK_COLOR_SCHEME="prefer-dark"`

## Autostart Setup

To make the script run automatically at startup:
1. Create a **.desktop** file:
   
`nano ~/.config/autostart/auto_theme_switcher.desktop`

2. Add the following content:
   
```
[Desktop Entry]
Type=Application
Name=Auto Theme Switcher
Exec=/home/YOUR_USERNAME/bin/auto_theme_switcher.sh
NoDisplay=true
X-GNOME-Autostart-enabled=true
```

## Usage

The script will run in the background and automatically switch themes based on the configured times. You can:

- Run it manually:
  
`~/bin/auto_theme_switcher.sh`

- Check the error log:
  
`cat ~/bin/auto_theme_switcher_errors.log`

## Troubleshooting

1. If themes don't switch:
   - Verify that the specified themes are installed
   - Check the error log file
   - Ensure the script has execution permissions

2. If the script doesn't start automatically:
   - Check the autostart **.desktop** file permissions
   - Verify the path in the **.desktop** file
   - Check system logs for potential errors

## Error Logging
The script logs errors to:
`~/bin/auto_theme_switcher_errors.log`

## License
This project is licensed under the MIT License.

## Acknowledgments
- GNOME Desktop Environment
- GTK Theme developers
- Icon Theme developers
