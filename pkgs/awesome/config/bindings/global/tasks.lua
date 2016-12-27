local awful = require('awful')

local prefs = require('preferences')
local modkey = prefs.modkey

local keys = awful.util.table.join({}
  , awful.key({ modkey, 'Control' }, 'n', awful.client.restore)
  )

local buttons = awful.util.table.join({}
  , awful.button({ }, 1, function (c)
      if c == client.focus then
        c.minimized = true
      else
        c.minimized = false
        if not c:isvisible() then
          awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
      end
    end)
  , awful.button({ }, 3, function ()
      if instance then
        instance:hide()
        instance = nil
      else
        instance = awful.menu.clients({ width=250 })
      end
    end)
  , awful.button({ }, 4, function ()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end
    end)
  , awful.button({ }, 5, function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end)
  )

return { keys = keys
       , buttons = buttons
       }
