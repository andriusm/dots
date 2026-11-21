#!/bin/sh

# echo "$(date +%T.%N) PV    $1" >> /tmp/lf-debug.log

case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.mp3) ffprobe -hide_banner -i "$1" 2>&1 ;;
    *.m4a) ffprobe -hide_banner -i "$1" 2>&1 ;;
    *.wav) ffprobe -hide_banner -i "$1" 2>&1 ;;
    *.ogg) ffprobe -hide_banner -i "$1" 2>&1 ;;
    *.webm) ffprobe -hide_banner -i "$1" 2>&1 ;;
    *.mp4) f="`basename \"$1\"`" && o="/tmp/${f}_thumb.jpg" && ffmpegthumbnailer -i "$1" -o "$o" -s0 >/dev/null 2>&1 && viu -w 80 -b "$o" ;;
    *.mkv) f="`basename \"$1\"`" && o="/tmp/${f}_thumb.jpg" && ffmpegthumbnailer -i "$1" -o "$o" -s0 >/dev/null 2>&1 && viu -w 80 -b "$o" ;;
    *.mpg) f="`basename \"$1\"`" && o="/tmp/${f}_thumb.jpg" && ffmpegthumbnailer -i "$1" -o "$o" -s0 >/dev/null 2>&1 && viu -w 80 -b "$o" ;;
    *.m4v) f="`basename \"$1\"`" && o="/tmp/${f}_thumb.jpg" && ffmpegthumbnailer -i "$1" -o "$o" -s0 >/dev/null 2>&1 && viu -w 80 -b "$o" ;;
    *.avi) f="`basename \"$1\"`" && o="/tmp/${f}_thumb.jpg" && ffmpegthumbnailer -i "$1" -o "$o" -s0 >/dev/null 2>&1 && viu -w 80 -b "$o" ;;
    *.jpg|*.jpeg|*.png|*.gif|*.webp|*.JPG|*.JPEG|*.PNG|*.GIF|*.WEBP)
       info=$(exiv2 "$1" 2>/dev/null | grep -E '^(Image size|Camera model|Image timestamp|Exposure time|Aperture|ISO speed|Focal length) ' | grep -Ev ':[[:space:]]*$' || true)
       n=0
       [ -n "$info" ] && echo "$info" && n=$(($(echo "$info" | wc -l) + 1))
       kitten icat --stdin no --transfer-mode stream --place "${2}x$(($3 - n))@${4}x$(($5 + n))" "$1" </dev/null >/dev/tty
       exit 1 ;;
    *.7z) 7z l "$1";;
    *.pdf) pdftotext "$1" -;;
    *) highlight -O ansi "$1" || cat "$1";;
esac
