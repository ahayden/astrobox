#!/bin/bash
Xvfb :10 -screen 0 1366x768x24 &
x11vnc -ncache 0 -nopw -display :10 -N -forever &
sleep 5 
xterm &
wmaker
