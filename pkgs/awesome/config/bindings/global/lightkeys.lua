local awful = require('awful')
local naughty = require('naughty')

local prefs = require('preferences')
local modkey = prefs.modkey

function say(text) naughty.notify({ text = text }) end
function sayShell(cmd) say(awful.util.pread(cmd)) end
function sayBrightness() sayShell('/run/current-system/sw/bin/xbacklight -get') end

local keys = awful.util.table.join({}
  ,    awful.key({ }, "XF86MonBrightnessDown",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -dec 10') ; sayBrightness() end)
  ,    awful.key({'Shift'}, "XF86MonBrightnessDown",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -dec 1') ; sayBrightness()  end)
  ,    awful.key({}, "XF86MonBrightnessUp",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -inc 10') ; sayBrightness() end)
  ,    awful.key({'Shift'}, "XF86MonBrightnessUp",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -inc 1') ; sayBrightness() end)

  ,    awful.key({ modkey }, "F6",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -inc 10') ; sayBrightness() end)
  ,    awful.key({ modkey, 'Shift'}, "F6",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -inc 1') ; sayBrightness() end)
  ,    awful.key({ modkey }, "F5",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -dec 10') ; sayBrightness() end)  
  ,    awful.key({ modkey, 'Shift'}, "F5",  function () awful.util.spawn('/run/current-system/sw/bin/xbacklight -dec 1') ; sayBrightness() end)
)
return { keys = keys }
