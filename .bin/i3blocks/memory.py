#!/usr/bin/env python3
"""Reports free memory."""

import os
from subprocess import Popen
import psutil

if os.environ.get('BLOCK_BUTTON') == "1":
    Popen(['alacritty', '-e', 'htop'])

AVAIL = str(int(psutil.virtual_memory().available/(1024*1024*1024))) + "GB"
print(AVAIL)
print(AVAIL)
