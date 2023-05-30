# Load Xresources
[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

# Set keyboard layout
setxkbmap -layout se,us -option grp:alt_shift_toggle

# Start!
exec awesome
export DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/dbus-g31c5aMlkt,guid=dd2fc76118c2686fe766299a64595978
DBUS_SESSION_BUS_PID=33715
