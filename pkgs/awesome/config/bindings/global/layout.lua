local awful = require('awful')
local layouts = require('layouts')

local prefs = require('preferences')
local modkey = prefs.modkey

local keys = awful.util.table.join({}
  , awful.key({ modkey,           }, 'j', function ()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end
    end)
  , awful.key({ modkey,           }, 'k', function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end)
  , awful.key({ modkey, 'Shift'   }, 'j', function () awful.client.swap.byidx(  1)    end)
  , awful.key({ modkey, 'Shift'   }, 'k', function () awful.client.swap.byidx( -1)    end)
  , awful.key({ modkey, 'Control' }, 'j', function () awful.screen.focus_relative( 1) end)
  , awful.key({ modkey, 'Control' }, 'k', function () awful.screen.focus_relative(-1) end)
  , awful.key({ modkey,           }, 'u', awful.client.urgent.jumpto)
  , awful.key({ modkey,           }, 'Tab', function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end)
  , awful.key({ modkey,           }, 'l',     function () awful.tag.incmwfact( 0.05)    end)
  , awful.key({ modkey,           }, 'h',     function () awful.tag.incmwfact(-0.05)    end)
  , awful.key({ modkey, 'Shift'   }, 'h',     function () awful.tag.incnmaster( 1)      end)
  , awful.key({ modkey, 'Shift'   }, 'l',     function () awful.tag.incnmaster(-1)      end)
  , awful.key({ modkey, 'Control' }, 'h',     function () awful.tag.incncol( 1)         end)
  , awful.key({ modkey, 'Control' }, 'l',     function () awful.tag.incncol(-1)         end)
  , awful.key({ modkey,           }, 'space', function () awful.layout.inc(layouts,  1) end)
  , awful.key({ modkey, 'Shift'   }, 'space', function () awful.layout.inc(layouts, -1) end)
  )

return { keys = keys }
