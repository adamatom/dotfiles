#!/usr/bin/env python3
"""Check for arch updates. Click to launch updater."""
from subprocess import check_output


UPDATE_COUNT = int(check_output('yay -Qu | wc -l', shell=True).decode("utf-8"))


if UPDATE_COUNT == 0:
    print(' ')
    print(' ')
else:
    print(' ' + str(UPDATE_COUNT))
    print(' ' + str(UPDATE_COUNT))
