local awful = require('awful')
local wibox = require('wibox')
local wallpaper = require('wallpaper')
local taglistbuttons = require('bindings.global.tags').buttons
local tasklistbuttons = require('bindings.global.tasks').buttons

local clock = awful.widget.textclock('%Y-%b%m-%a%d %H:%M:%S', 1)


local tasklists = require('wiboxes.tasklists')

awful.screen.connect_for_each_screen(function(s)

    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    wallpaper(s) -- set wallpaper
    s.mypromptbox = awful.widget.prompt()
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglistbuttons)
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklistbuttons)

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(s.mytaglist)
    left_layout:add(s.mypromptbox)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(wibox.widget.systray())
    right_layout:add(clock)
    right_layout:add(s.mylayoutbox)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(s.tasklists)
    layout:set_right(right_layout)

    s.mywibox:set_widget(layout)
end)
