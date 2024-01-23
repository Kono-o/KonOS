#!/bin/sh
echo -ne '\033c\033]0;KonOS\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/KonOS.x86_64" "$@"
