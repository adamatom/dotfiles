#!/usr/bin/env python3
"""Dynamically update i3wm workspace names based on running applications."""

import argparse
import json
import os.path
import re

import i3ipc

from i3_icons import icons

I3_CONFIG_PATHS = (os.path.expanduser("~/.i3"),
                   os.path.expanduser("~/.config/i3"))

DEFAULT_APP_ICON_CONFIG = {
    "chromium-browser": "chrome",
    "firefox": "firefox",
    "qutebrowser": "pills",
    "alacritty": "terminal",
    "kitty": "terminal",
    "evolution": "envelope",
    "thunderbird": "envelope",
    "thunar": "folder-open",
    "spotify": "music",
    "vim": "vim",
    "todo": "todo",
    "libreoffice-writer": "file-word",
    "libreoffice-impress": "file-powerpoint",
    "libreoffice-calc": "file-excel",
    "weechat": "weechat"
}

FILTERS = [
    (re.compile('todo.md.*'), 'todo'),
    (re.compile('.* - VIM$'), 'vim'),
    (re.compile('weechat'), 'weechat'),
]


def build_rename(i3, app_icons, delim):
    """
    Build rename callback function to pass to i3ipc.

    i3: i3ipc.i3ipc.Connection
    app_icons: dict[str, str]
        Index of application-name (from i3) to icon-name (in nerd fonts).
    delim: `str`
        Delimiter to use when build workspace name from app names/icons.

    returns func: The rename callback.
    """
    def filter_title(name):
        # look for specific window titles and reinterpret if match found
        for filter_re, new_name in FILTERS:
            if filter_re.match(name):
                return True, new_name
        return False, name

    def get_icon_or_name(leaf):
        filtered, new_name = filter_title(str(leaf.name))  # coerce to string

        if filtered:
            name = new_name
        elif leaf.window_class:
            name = leaf.window_class.lower()
        else:
            name = leaf.name.lower()

        if name in app_icons and app_icons[name] in icons:
            return icons[app_icons[name]]
        else:
            return name.lower()

    def rename(i3, e):
        workspaces = i3.get_tree().workspaces()
        # need to use get_workspaces since the i3 con object doesn't have the
        # visible property for some reason
        workdicts = i3.get_workspaces()
        visible = [w['name'] for w in workdicts if w['visible']]
        visworkspaces = []
        focus = ([w['name'] for w in workdicts if w['focused']] or [None])[0]
        focusname = None

        commands = []
        for workspace in workspaces:
            names = [get_icon_or_name(leaf)
                     for leaf in workspace.leaves()]
            names = delim.join(names)
            if int(workspace.num) > 0:
                newname = f'{workspace.num}: {names}'
            else:
                newname = names

            if workspace.name in visible:
                visworkspaces.append(newname)
            if workspace.name == focus:
                focusname = newname
            cmd = f'rename workspace "{workspace.name}" to "{newname}"'
            commands.append(cmd)

        for workspace in visworkspaces + [focusname]:
            commands.append(f'workspace "{workspace}"')

        # we have to join all the activate workspaces commands into one or the
        # order might get scrambled by multiple i3-msg instances running
        # asyncronously causing the wrong workspace to be activated last, which
        # changes the focus.
        cmds = ';'.join(commands)
        i3.command(cmds)
    return rename


def _get_i3_dir():
    # standard i3-config directories
    for path in I3_CONFIG_PATHS:
        if os.path.isdir(path):
            return path
    err = ('Could not find i3 config path, ' +
           f'expected one of {I3_CONFIG_PATHS} to be present')
    raise SystemExit(err)


def _get_app_icons(config_path=None):
    """
    Get app-icon mapping from config file or use defaults.

    Parameters
    ----------
    config_path: `str|None`
        Path to app-icon config file.

    Returns
    -------
    dict[str,str]
        Index of application-name (from i3) to icon-name (in nerd fonts).

    Raises
    ------
    json.decoder.JSONDecodeError
        When app-icon config file is not in JSON format.

    SystemExit
        When `config_path is not None` and there is not a file available at
        that path.  When ~/.i3 or ~/.config/i3 is not a directory (ie. i3 is
        not installed).

    Notes
    -----
    If config_path is None then the locations ~/.i3/app-icons.json and
    ~/.config/i3/app-icons.json will also be used if available. If they are
    also not available then `DEFAULT_APP_ICON_CONFIG` will be used.

    """
    if config_path:
        if not os.path.isfile(config_path):
            err = f'App-icon config path {config_path} does not exist'
            raise SystemExit(err)
    else:
        config_path = os.path.join(_get_i3_dir(), "app-icons.json")

    if os.path.isfile(config_path):
        with open(config_path) as f:
            app_icons = json.load(f)
        # normalise app-names to lower
        return {k.lower(): v for k, v in app_icons.items()}
    else:
        print(f'Using default app-icon config {DEFAULT_APP_ICON_CONFIG}')
        return dict(DEFAULT_APP_ICON_CONFIG)


def main():
    """Main."""
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("-config-path",
                        help=('Path to file that maps applications to icons ' +
                              'in json format. Defaults to ' +
                              '~/.i3/app-icons.json or ' +
                              '~/.config/i3/app-icons.json or hard-coded ' +
                              'list if they are not available.'),
                        required=False)
    parser.add_argument("-d", "--delimiter",
                        help=('The delimiter used to separate multiple ' +
                              'window names in the same workspace.'),
                        required=False,
                        default="|")
    args = parser.parse_args()

    app_icons = _get_app_icons(args.config_path)

    # check for missing icons
    for app, icon_name in app_icons.items():
        if icon_name not in icons:
            print(f'Specified icon {icon_name} for app {app} does not exist!')

    # build i3-connection
    i3 = i3ipc.Connection()

    rename = build_rename(i3, app_icons, args.delimiter)
    cases = ['window::move', 'window::new', 'window::title', 'window::close']
    for case in cases:
        i3.on(case, rename)
    i3.main()


if __name__ == '__main__':
    main()
