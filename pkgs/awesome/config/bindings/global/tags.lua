local awful = require('awful')
local tags = require('tags')
local modkey = require('preferences').modkey

local keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
local keys = awful.util.table.join({}
  , awful.key({ modkey,           }, 'Left', awful.tag.viewprev)
  , awful.key({ modkey,           }, 'Right', awful.tag.viewnext)
  )

for i = 1, keynumber do
  keys = awful.util.table.join(keys
  , awful.key({ modkey }, '#' .. i + 9, function ()
      local screen = mouse.screen
      if tags[screen][i] then
        awful.tag.viewonly(tags[screen][i])
      end
    end)
  , awful.key({ modkey, 'Control' }, '#' .. i + 9, function ()
      local screen = mouse.screen
        if tags[screen][i] then
          awful.tag.viewtoggle(tags[screen][i])
      end
    end)
  , awful.key({ modkey, 'Shift' }, '#' .. i + 9, function ()
      if client.focus and tags[client.focus.screen][i] then
        awful.client.movetotag(tags[client.focus.screen][i])
      end
    end)
  , awful.key({ modkey, 'Control', 'Shift' }, '#' .. i + 9, function ()
      if client.focus and tags[client.focus.screen][i] then
        awful.client.toggletag(tags[client.focus.screen][i])
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
