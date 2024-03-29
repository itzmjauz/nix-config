-- solarized awesome theme --

local theme = {}

theme.colors = {}
theme.colors.base03  = "#002b36"
theme.colors.base02  = "#073642"
theme.colors.base01  = "#586e75"
theme.colors.base00  = "#657b83"
theme.colors.base0   = "#839496"
theme.colors.base1   = "#93a1a1"
theme.colors.base2   = "#eee8d5"
theme.colors.base3   = "#fdf6e3"
theme.colors.yellow  = "#b58900"
theme.colors.orange  = "#cb4b16"
theme.colors.red     = "#dc322f"
theme.colors.magenta = "#d33682"
theme.colors.violet  = "#6c71c4"
theme.colors.blue    = "#268bd2"
theme.colors.cyan    = "#2aa198"
theme.colors.green   = "#859900"

-- {{{ Styles
theme.font          = 'Source Code Pro 11'


-- {{{ Colors
theme.bg_normal  = theme.colors.base02
theme.bg_focus   = theme.colors.base2
theme.bg_urgent  = theme.colors.base2
theme.bg_systray = theme.bg_normal

theme.fg_normal  = theme.colors.base3
theme.fg_focus   = theme.colors.orange
theme.fg_urgent  = theme.colors.red
-- }}}

-- {{{ Borders
theme.border_width  = "1"
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.colors.cyan
theme.border_marked = theme.bg_urgent
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = theme.colors.green

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = '#ff0000'

-- Display the taglist squares
theme.tasklist_floating_icon = '/usr/share/awesome/themes/default/tasklist/floatingw.png'

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = '/usr/share/awesome/themes/default/submenu.png'
theme.menu_height = '15'
theme.menu_width  = '100'

-- You can use your own command to set your wallpaper
theme.wallpaper = theme.bg_normal

-- You can use your own layout icons like this:
theme.layout_fairh = '/usr/share/awesome/themes/default/layouts/fairhw.png'
theme.layout_fairv = '/usr/share/awesome/themes/default/layouts/fairvw.png'
theme.layout_floating  = '/usr/share/awesome/themes/default/layouts/floatingw.png'
theme.layout_magnifier = '/usr/share/awesome/themes/default/layouts/magnifierw.png'
theme.layout_max = '/usr/share/awesome/themes/default/layouts/maxw.png'
theme.layout_fullscreen = '/usr/share/awesome/themes/default/layouts/fullscreenw.png'
theme.layout_tilebottom = '/usr/share/awesome/themes/default/layouts/tilebottomw.png'
theme.layout_tileleft   = '/usr/share/awesome/themes/default/layouts/tileleftw.png'
theme.layout_tile = '/usr/share/awesome/themes/default/layouts/tilew.png'
theme.layout_tiletop = '/usr/share/awesome/themes/default/layouts/tiletopw.png'
theme.layout_spiral  = '/usr/share/awesome/themes/default/layouts/spiralw.png'
theme.layout_dwindle = '/usr/share/awesome/themes/default/layouts/dwindlew.png'

theme.awesome_icon = '/usr/share/awesome/icons/awesome16.png'

return theme
