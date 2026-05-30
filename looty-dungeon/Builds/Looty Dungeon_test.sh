#!/bin/sh
printf '\033c\033]0;%s\a' Looty Dungeon
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Looty Dungeon_test.x86_64" "$@"
