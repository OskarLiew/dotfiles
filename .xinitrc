# Load Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Set keyboard layout
setxkbmap -layout se,us -option grp:alt_shift_toggle

# Start!
exec awesome
