#!/usr/bin/env python3
"""Check for arch updates. Click to launch updater."""
from subprocess import check_output, CalledProcessError, Popen
import os


def get_update_count():
    """Get non-aur package count."""
    output = str(check_output(['checkupdates']))
    if output == "":
        return 0
    return output.count("\\n")


def get_aur_update_count():
    """Get aur package count."""
    pending_updates = b""
    try:
        pending_updates = str(check_output(["cower", "-bu"]))
    except CalledProcessError as cp_error:
        pending_updates = cp_error.output
    return str(pending_updates).count("\\n")


if os.environ.get('BLOCK_BUTTON') == "1":
    COMMAND = 'terminator -e pacaur -Syu; printf "\npress enter to exit"; read'
    Popen(COMMAND.split(' ', 1)).wait()


UPDATE_COUNT = get_update_count()
UPDATE_COUNT += get_aur_update_count()

if UPDATE_COUNT == 0:
    print('  ')
    print('  ')
else:
    print(' ' + str(UPDATE_COUNT))
    print(' ' + str(UPDATE_COUNT))
