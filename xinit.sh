#!/bin/bash
Xvfb :10 -screen 0 1396x876x24 &
x11vnc -noipv6 -xkb -noxdamage -xfixes -noxrecord -noscrollcopyrect \
  -wireframe -nowcr -nopw -nonc \
  -noserverdpms -nodpms -display :10 -N -nevershared -forever &
sleep 5 
xrdb -merge /usr/local/Xdefaults
xterm &
metacity 2> /dev/null
