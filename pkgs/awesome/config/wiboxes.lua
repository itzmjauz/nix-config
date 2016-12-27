local awful = require('awful')
local wibox = require('wibox')

local clock = awful.widget.textclock('%Y-%b%m-%a%d %H:%M:%S', 1)

local wiboxes = {}
local layoutboxes = {}

local promptboxes = require('wiboxes.promptboxes')
local taglists = require('wiboxes.taglists')
local tasklists = require('wiboxes.tasklists')

for s = 1, screen.count() do
    layoutboxes[s] = awful.widget.layoutbox(s)
    wiboxes[s] = awful.wibox({ position = 'top', screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(taglists[s])
    left_layout:add(promptboxes[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(clock)
    right_layout:add(layoutboxes[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(tasklists[s])
    layout:set_right(right_layout)

    wiboxes[s]:set_widget(layout)
end
