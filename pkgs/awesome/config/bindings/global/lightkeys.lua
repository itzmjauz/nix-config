local awful = require('awful')

local prefs = require('preferences')
local modkey = prefs.modkey

local keys = awful.util.table.join({}
  ,    awful.key({ }, "XF86MonBrightnessDown",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -dec 10')  end)
  ,    awful.key({'Shift'}, "XF86MonBrightnessDown",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -dec 1')  end)
  ,    awful.key({}, "XF86MonBrightnessUp",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -inc 10') end)
  ,    awful.key({'Shift'}, "XF86MonBrightnessUp",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -inc 1') end)

  ,    awful.key({ modkey }, "F6",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -inc 10')  end)
  ,    awful.key({ modkey, 'Shift'}, "F6",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -inc 1')  end)
  ,    awful.key({ modkey }, "F5",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -dec 10') end)  
  ,    awful.key({ modkey, 'Shift'}, "F5",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -dec 1') end)
)
return { keys = keys }
