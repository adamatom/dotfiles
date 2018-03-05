#!/usr/bin/env python3
"""Draws a barchart representing CPU load."""
import os
from subprocess import Popen
import psutil


def get_icon(load):
    """Return a font character representing an icon given a 0-100 CPU load."""
    ramp = ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█']
    load = max(min(70, load), 0)
    return ramp[int(load/10)]


if os.environ.get('BLOCK_BUTTON') == "1":
    Popen(['alacritty', '-e', 'htop'])

CORES = psutil.cpu_percent(interval=0.2, percpu=True)
RESULT = ' '.join(map(get_icon, CORES))

print(RESULT)
print(RESULT)
