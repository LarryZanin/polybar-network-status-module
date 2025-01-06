# polybar-network-status-module
A custom Polybar module that displays network status and allows network management directly from the bar.


## FEATURES:
-    Network Status Display: Shows the current network connection status(icon and info modes).
    Interactive Actions:
-    Left Click: Toggles network information on/off(icon,ssid, ip, downloading speed, ping to google).
-    Right Click: Opens a graphical interface for network management (nmtui).
-    Real-Time Updates: Uses IPC hooks to keep the information up to date(once per second in information mode, and once per 15 seconds in icon mode).
-    Easy Setup: Seamlessly integrates into your existing Polybar configuration.


## INSTALLATION:
    Execute these commands sequentially.
####    1)Clone the repository:
        git clone https://github.com/yourusername/polybar-network-status.git
####    2)Copy the scripts to the polybar-scripts directory and make them executable:
        mkdir -p ~/polybar-scripts
        cp polybar-network-status/refresh-network-status.sh ~/polybar-scripts/
        cp polybar-network-status/network-status.sh ~/polybar-scripts/
        cp polybar-network-status/NetGUI.sh ~/polybar-scripts/
        chmod +x ~/polybar-scripts/refresh-network-status.sh
        chmod +x ~/polybar-scripts/network-status.sh
        chmod +x ~/polybar-scripts/NetGUI.sh
####    3)Add the module to your Polybar configuration file (yourwaytopolybar/polybar/config):

        ##MAKE SHURE YOU HAVE ENABLED IPC MODULES IN YOUR POLYBAR CONFIG##
        ##[bar/yourbarname]##
        ##enable-ipc = true##
		
        [module/network-status]
        type = custom/ipc
        hook-0 = ~/polybar-scripts/network-status.sh &
        hook-1 = ~/polybar-scripts/network-status.sh info &
        initial = 1
        label = %output%
        click-left = ~/polybar-scripts/network-status.sh toggle &
        click-right = ~/polybar-scripts/NetGUI.sh

####    4)Add the module to your Polybar bar:
        [bar/yourbarname]
        modules-right = network-status

####    5*)Restart Polybar if opened:
        polybar-msg cmd restart

## USAGE:
-    By default this module shows icon of network connection type.
-    Left Click on the module toggles the network information (icon/info).
-    Right Click opens a graphical interface for network management (nmtui).

## SCRIPTS USED:
-    refresh-network-status.sh: Script for refreshing network information.
-    network-status.sh: Script for retrieving and outputting the network state.
-    NetGUI.sh: Script for launching a graphical interface for network management.

## REQUIREMENTS:
-    Polybar
-    NetworkManager
-    nmcli(for managing NetworkManager)
-    alacritty (you can change it to your terminal emulator in NetGUI.sh)
-    some Nerd fonts font (for correct display of glyphs)

## CONTRIBUTION:
    Contributions are welcome! Feel free to open issues and submit pull requests for suggestions and improvements.

## LICENSE:
    This project is licensed under the MIT License. See LICENSE for details.
