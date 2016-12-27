local awful = require('awful')

local prefs = require('preferences')
local modkey = prefs.modkey

local keys = awful.util.table.join({}
  , awful.key({ modkey,           }, 'w', function () awful.util.spawn(prefs.browser) end)
  , awful.key({ modkey, 'Shift'   }, 'w', function () awful.util.spawn(prefs.browser .. ' --incognito') end)
  , awful.key({ modkey,           }, 'Escape', function () awful.util.spawn(prefs.off or 'off') end)
  , awful.key({ modkey, 'Shift'   }, 'Escape', function () awful.util.spawn(prefs.lock or 'lock') end)
  , awful.key({ modkey,           }, 'Return', function () awful.util.spawn(prefs.terminal) end)
  , awful.key({ modkey,           }, 'KP_Enter', function () awful.util.spawn(prefs.terminal) end)
  )

return { keys = keys }
