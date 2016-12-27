-- solarized awesome theme --

local theme = {}

theme.font          = 'Source Code Pro 6'

theme.bg_normal     = '#002b36'
theme.bg_focus      = '#073642'
theme.bg_urgent     = '#cb4b16'
theme.bg_minimize   = '#002b36'

theme.fg_normal     = '#839496'
theme.fg_focus      = '#93a1a1'
theme.fg_urgent     = '#93a1a1'
theme.fg_minimize   = '#657b83'

theme.border_width  = '1'
theme.border_normal = '#000000'
theme.border_focus  = '#073642'
theme.border_marked = '#d33682'

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
