"""qutebrowser config."""
from qutebrowser.config.config import ConfigContainer  # noqa: F401
# pylint: disable=C0111
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401

config = config  # type: ConfigAPI # noqa: F821 pylint: disable=E0602,C0103
c = c  # type: ConfigContainer # noqa: F821 pylint: disable=E0602,C0103


# Uncomment this to still load settings configured via autoconfig.yml
# config.load_autoconfig()

# Load a restored tab as soon as it takes focus.
# Type: Bool
c.session.lazy_restore = False

# Always restore open sites when qutebrowser is reopened.
# Type: Bool
c.auto_save.session = True

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'file://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome://*/*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'qute://*/*')

# Height (in pixels or as percentage of the window) of the completion.
# Type: PercOrInt
c.completion.height = '33%'

# Minimum amount of characters needed to update completions.
# Type: Int
c.completion.min_chars = 1

# Characters used for hint strings.
# Type: UniqueCharString
c.hints.chars = 'fasdghjkl'

# Enable smooth scrolling for web pages. Note smooth scrolling does not
# work with the `:scroll-px` command.
# Type: Bool
c.scrolling.smooth = True

c.tabs.title.format = "{audio}{private}{index}: {perc} {title}"

c.tabs.title.format_pinned = "{audio}{private}{index}: {perc} {title}"

c.spellcheck.languages = ['en-US']

# Switch between tabs using the mouse wheel.
# Type: Bool
c.tabs.mousewheel_switching = False

# When to show the tab bar.
# Type: String
# Valid values:
#   - always: Always show the tab bar.
#   - never: Always hide the tab bar.
#   - multiple: Hide the tab bar if only one tab is open.
#   - switching: Show the tab bar when switching tabs.
c.tabs.show = 'always'
c.tabs.position = 'left'
c.tabs.width = '10%'

# Open a new window for every tab.
# Type: Bool
c.tabs.tabs_are_windows = False

# Support hidpi
c.qt.highdpi = True

# Fonts
c.fonts.completion.entry = '12pt EssentialPragmataPro Nerd Font'
c.fonts.completion.category = 'bold 12pt EssentialPragmataPro Nerd Font'
c.fonts.debug_console = '12pt EssentialPragmataPro Nerd Font'
c.fonts.downloads = '12pt EssentialPragmataPro Nerd Font'
c.fonts.hints = '8pt EssentialPragmataPro Nerd Font'
c.fonts.keyhint = '12pt EssentialPragmataPro Nerd Font'
c.fonts.messages.error = '12pt EssentialPragmataPro Nerd Font'
c.fonts.messages.info = '12pt EssentialPragmataPro Nerd Font'
c.fonts.messages.warning = '12pt EssentialPragmataPro Nerd Font'
c.fonts.prompts = '12pt EssentialPragmataPro Nerd Font'
c.fonts.statusbar = '12pt EssentialPragmataPro Nerd Font'
c.fonts.tabs = '12pt EssentialPragmataPro Nerd Font'


# Colors
config.source('dracula_theme.py')

# Minimize fingerprinting
# unfortunately, artifactory needs canvas reading and we cant whitelist just
# one site.
# c.content.canvas_reading = False
c.content.webgl = False

# Autoplay videos on load?
c.content.autoplay = False

# Close window on last tab close
c.tabs.last_close = 'close'

# Key binds
config.bind('<Space>r', 'restart')
config.bind('<Space>p', 'spawn --userscript qute-pass')
config.bind('<Space>P', 'spawn --userscript qute-pass --password-only')
config.bind('<Ctrl-Shift-p>', 'open --private')

c.aliases['tabnew'] = 'open -t'

def link_bind(chars: str, uri):
    """Generate a binding to a uri."""
    config.bind(f'<Space>G{chars}', f'open {uri}')
    config.bind(f'<Space>g{chars}', f'open -t {uri}')


link_bind('c', 'http://confluence.is.idexx.com')
link_bind('j', 'http://jira.is.idexx.com')
link_bind('ba', 'http://bamboo.is.idexx.com')
link_bind('bi', 'http://bitbucket.is.idexx.com')
link_bind('a', 'http://bitbucket.is.idexx.com')
