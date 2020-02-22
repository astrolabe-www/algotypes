#!/bin/bash

export DISPLAY=:0
xrandr -o normal
xinput set-prop "RPI_TOUCH By ZH851" --type=float "Coordinate Transformation Matrix" 0 0 0 0 0 0 0 0 0
