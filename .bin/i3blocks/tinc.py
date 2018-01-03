#!/usr/bin/env python3
"""Check for tinc connectivity. Click to toggle."""
from subprocess import check_output, Popen
import os


def tinc_connected():
    """Get non-aur package count."""
    tap0 = '/sbin/ifconfig tap0 >/dev/null 2>&1 && echo -n "1" || echo -n "0"'
    output = check_output([tap0], shell=True)
    return output == b'1'


CONNECTED = tinc_connected()

if os.environ.get('BLOCK_BUTTON') == "1":
    if CONNECTED:
        COMMAND = 'sudo killall tincd'
        Popen(COMMAND, shell=True).wait()
        CONNECTED = False
    else:
        COMMAND = 'sudo tincd -n idexx'
        Popen(COMMAND, shell=True).wait()
        CONNECTED = True


if CONNECTED:
    print(' tincd ')
    print(' tincd ')
else:
    print(' -- ')
    print(' -- ')
