#!/usr/bin/python

# https://dbus.freedesktop.org/doc/dbus-python/api/

from gi.repository import GLib
import dbus
from dbus.mainloop.glib import DBusGMainLoop
from pprint import pprint
import sys

status = ""
artist = ""
title = ""

def notifications(interface, message, ahhh):
    global artist
    global title
    global status
    try:
        if "Metadata" in message:
            artist = message["Metadata"]["xesam:artist"][0]
            title = message["Metadata"]["xesam:title"]
        if "PlaybackStatus" in message:
            status = {"Paused" : "", "Playing" : ""}.get(message["PlaybackStatus"])

        if status and artist and title:
            print(status + " " + artist + " - " + title)
        else:
            print("")

        sys.stdout.flush()
    except Exception:
        pass


def updown(bus, name_was, name_is):
    if bus.startswith('org.mpris.MediaPlayer2.'):
        if not name_is:
            print("")
            sys.stdout.flush()


if __name__ == '__main__':
    DBusGMainLoop(set_as_default=True)

    session_bus = dbus.SessionBus()
    session_bus.add_signal_receiver(
            handler_function=notifications,
            signal_name='PropertiesChanged',
            dbus_interface='org.freedesktop.DBus.Properties',
            path='/org/mpris/MediaPlayer2'
    )

    session_bus.add_signal_receiver(
            handler_function=updown,
            signal_name='NameOwnerChanged'
    )

    mainloop = GLib.MainLoop()
    mainloop.run()
