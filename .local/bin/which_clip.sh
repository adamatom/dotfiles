#!/usr/bin/env bash

if command -v wl-copy >/dev/null 2>&1; then
    wl-copy
elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard
else
    echo "Error: Neither wl-copy nor xclip found in PATH" >&2
    exit 1
fi
