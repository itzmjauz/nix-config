local awful = require('awful')
local wibox = require('wibox')
local layouts = require('layouts')
local beautiful = require('beautiful')
local gears = require('gears')

local taglistbuttons = require('bindings.global.tags').buttons
local tasklistbuttons = require('bindings.global.tasks').buttons

local clock = awful.widget.textclock('%Y-%b%m-%a%d %H:%M:%S', 1)

awful.screen.connect_for_each_screen(function(s)
    local function set_wallpaper(s)
        if beautiful.wallpaper then
            local wallpaper = beautiful.wallpaper
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)
            gears.wallpaper.maximized('/etc/nixos/pkgs/awesome/config/nixos-bg.png', s, true)
        end
    end
   
    set_wallpaper(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, layouts[1])
    s.mypromptbox = awful.widget.prompt()
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglistbuttons)
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklistbuttons)

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(s.mytaglist)
--    left_layout:add(s.mypromptbox)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(wibox.widget.systray())
    right_layout:add(clock)
    right_layout:add(s.mylayoutbox)

    -- Widgets that align to the middle
    local middle_layout = wibox.layout.fixed.horizontal()
    middle_layout:add(s.mytasklist)
    middle_layout:add(s.mypromptbox)
    middle_layout.expand = "outside"

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(middle_layout)
    layout:set_right(right_layout)

    s.mywibox:set_widget(layout)
    screen.connect_signal("property::geometry", set_wallpaper)
end)
