#!/usr/bin/env python3
"""Check for arch updates. Click to launch updater."""
from subprocess import check_output, CalledProcessError
import time


def get_update_count():
    """Get non-aur package count."""
    output = ""
    for _i in range(0, 5):
        try:
            output = check_output('checkupdates 2> /dev/null | wc -l',
                                  shell=True).decode("utf-8")
            return int(output)
        except CalledProcessError:
            time.sleep(0.5)

    return 0


def get_aur_update_count():
    """Get aur package count."""
    pending_updates = b""
    try:
        pending_updates = str(check_output(["cower", "-bu"]))
    except CalledProcessError as cp_error:
        pending_updates = cp_error.output
    return str(pending_updates).count("\\n")


UPDATE_COUNT = get_update_count()
UPDATE_COUNT_AUR = get_aur_update_count()

if UPDATE_COUNT + UPDATE_COUNT_AUR == 0:
    print(' ')
    print(' ')
else:
    print(' ' + str(UPDATE_COUNT))
    print(' ' + str(UPDATE_COUNT))
