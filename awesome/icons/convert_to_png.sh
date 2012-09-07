#!/usr/bin/env sh
for x in *.xbm; do convert -fill "$COLOR" -transparent white -colorize 60 -border 4x4 -bordercolor transparent "${x}" "${x%.*}.png"; done
