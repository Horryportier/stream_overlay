#!/bin/sh
echo -ne '\033c\033]0;stream_overlay\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/stream_overlay.x86_64" "$@"
