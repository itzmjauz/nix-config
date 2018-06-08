local awful = require('awful')
local modkey = require('preferences').modkey

local keynumber = 9
--for s = 1, screen.count() do
--   keynumber = math.min(9, math.max(#tags[s], keynumber))
--end

-- Bind all key numbers to tags.
local keys = awful.util.table.join({}
  , awful.key({ modkey,           }, 'Left', awful.tag.viewprev)
  , awful.key({ modkey,           }, 'Right', awful.tag.viewnext)
  )

for i = 1, keynumber do
  keys = awful.util.table.join(keys
  , awful.key({ modkey }, '#' .. i + 9, function ()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewonly(tag)
        tag:view_only()
      end
    end)
  , awful.key({ modkey, 'Control' }, '#' .. i + 9, function ()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end)
  , awful.key({ modkey, 'Shift' }, '#' .. i + 9, function ()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end)
  , awful.key({ modkey, 'Control', 'Shift' }, '#' .. i + 9, function ()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end)
  )
end

local buttons = awful.util.table.join({} 
, awful.button({ }, 1, awful.tag.viewonly)
, awful.button({ modkey }, 1, awful.client.movetotag)
, awful.button({ }, 3, awful.tag.viewtoggle)
)

return { keys = keys 
       , buttons = buttons
       }
