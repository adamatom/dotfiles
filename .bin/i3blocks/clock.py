#!/usr/bin/env python3
"""Prints the time given a format. Can also launch something when clicked."""
import os
from subprocess import Popen
import argparse
from time import localtime, strftime

def create_argparse():
    """Generate the argparse object."""
    parser = argparse.ArgumentParser(description='Print the time')
    parser.add_argument(
        '-c',
        '--click',
        default='',
        help='optional command to run on mouse click'
    )
    parser.add_argument('format')
    return parser.parse_args()

ARGS = create_argparse()

if ARGS.click != '' and os.environ.get('BLOCK_BUTTON') == '1':
    Popen(ARGS.click.split(' ', 1))

CLOCK = strftime(ARGS.format, localtime())
print(CLOCK)
print(CLOCK)
