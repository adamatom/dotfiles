#!/usr/bin/env python3
"""
Download the weather from Yahoo!
"""
import os
from subprocess import Popen
import argparse
import requests


def create_argparse():
    """Generate the argparse object."""
    parser = argparse.ArgumentParser(description='Check the weather')
    parser.add_argument(
        '-u',
        '--unit',
        default='f',
        help='f|c - what units to print(default=f)'
    )
    parser.add_argument(
        '-c',
        '--click',
        default='',
        help='optional command to run on mouse click'
    )
    parser.add_argument('woeid')
    return parser.parse_args()


def get_weather(woeid, units):
    """
    Grab the weather from Yahoo.

    Find your woeid using:
    http://woeid.rosselliot.co.nz/

    woeid: required woeid by Yahoo!
    units: 'f' or 'c'

    """
    qstr = 'select * from weather.forecast where ' + \
           'woeid="{woeid}" and u="{units}"'.format(woeid=woeid, units=units.lower())
    try:
        query = requests.get("https://query.yahooapis.com/v1/public/yql",
                             params={'q': qstr,
                                     'format': 'json',
                                     'env': 'store://datatables.org/alltableswithkeys'})
    #pylint: disable=broad-except
    except Exception:
        return None
    if query.status_code != 200:
        return None

    try:
        json_query = query.json()
        return json_query['query']['results']['channel']['item']['condition']
    except TypeError:
        return None

def get_icon(forecast):
    """
    Return an unicode icon based on the forecast code and text
    See: http://developer.yahoo.com/weather/#codes
    """
    code = int(forecast['code'])
    text = forecast['text'].lower()

    sunids = [31, 32, 33, 34, 36]
    cloudids = [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 44]
    rainids = [0, 1, 2, 3, 4, 5, 6, 9, 11, 12, 37, 38, 39, 40, 45, 47]
    snowids = [7, 8, 10, 13, 14, 15, 16, 17, 18, 35, 41, 42, 43, 46]

    if 'sun' in text or code in sunids:
        return ''

    if 'cloud' in text or code in cloudids:
        return ''

    if 'rain' in text or code in rainids:
        return ''

    if 'snow' in text or code in snowids:
        return '☃'

    return '??'


ARGS = create_argparse()

if ARGS.click != '' and os.environ.get('BLOCK_BUTTON') == '1':
    Popen(ARGS.click.split(' ', 1))

TODAY = get_weather(ARGS.woeid, ARGS.unit)

if TODAY is None:
    RESULT = ' ??'
else:
    RESULT = '{icon} {temp}{unit}'.format(
        icon=get_icon(TODAY), temp=TODAY['temp'], unit=ARGS.unit.upper())
print(RESULT)
print(RESULT)
