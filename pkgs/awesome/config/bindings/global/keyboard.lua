local awful = require('awful')
local naughty = require('naughty')

local prefs = require('preferences')
local modkey = prefs.modkey

local layouts = {"us", "ru"}
local n = 0
local function nextLayout()
  n = n + 1
  if layouts[n] == nil then
    n = 1
  end
  return layouts[n]
end

local function setLayout(layout)
  -- TODO: don't use a late-bound setxkbmap
  awful.util.spawn("/run/current-system/sw/bin/setxkbmap -layout " .. layout)
end

setLayout(nextLayout())

local keys = awful.util.table.join({}
  , awful.key({ modkey }, '=', function ()
      local layout = nextLayout()
      setLayout(layout)
      naughty.notify({ text = layout })
    end)
  )

return { keys = keys }
