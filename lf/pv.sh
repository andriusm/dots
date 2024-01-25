#!/bin/sh

case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.mp4) ffprobe -i "$1 2>&1";;
    *.mkv) ffprobe -i "$1 2>&1";;
    *.mpg) ffprobe -i "$1 2>&1";;
    *.m4v) ffprobe -i "$1 2>&1";;
    *.avi) ffprobe -i "$1 2>&1";;
    *.jpg) viu -b -h "$3" "$1" ;;
    *.jpeg) viu -b -h "$3" "$1" ;;
    *.png) viu -b -h "$3" "$1" ;;
    *.gif) viu -b -h "$3" "$1" ;;
    *.7z) 7z l "$1";;
    *.pdf) pdftotext "$1" -;;
    *) highlight -O ansi "$1" || cat "$1";;
esac
