#!/bin/sh

case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) unzip -l "$1";;
    *.rar) unrar l "$1";;
    # *.mp3) ffplay "$1" ;;
    *.mp4) f="`basename \"$1\"`" && o="/tmp/${f}_thumb.jpg" && ffmpegthumbnailer -i "$1" -o "$o" -s0 >/dev/null 2>&1 && viu -w 80 -b "$o" ;;
    *.mkv) f="`basename \"$1\"`" && o="/tmp/${f}_thumb.jpg" && ffmpegthumbnailer -i "$1" -o "$o" -s0 >/dev/null 2>&1 && viu -w 80 -b "$o" ;;
    *.mpg) f="`basename \"$1\"`" && o="/tmp/${f}_thumb.jpg" && ffmpegthumbnailer -i "$1" -o "$o" -s0 >/dev/null 2>&1 && viu -w 80 -b "$o" ;;
    *.m4v) f="`basename \"$1\"`" && o="/tmp/${f}_thumb.jpg" && ffmpegthumbnailer -i "$1" -o "$o" -s0 >/dev/null 2>&1 && viu -w 80 -b "$o" ;;
    *.avi) f="`basename \"$1\"`" && o="/tmp/${f}_thumb.jpg" && ffmpegthumbnailer -i "$1" -o "$o" -s0 >/dev/null 2>&1 && viu -w 80 -b "$o" ;;
    *.jpg) viu -b -h "$3" "$1" ;;
    *.jpeg) viu -b -h "$3" "$1" ;;
    *.png) viu -b -h "$3" "$1" ;;
    *.gif) viu -b -h "$3" "$1" ;;
    *.7z) 7z l "$1";;
    *.pdf) pdftotext "$1" -;;
    *) highlight -O ansi "$1" || cat "$1";;
esac
