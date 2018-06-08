local awful = require('awful')

local prefs = require('preferences')
local modkey = prefs.modkey

local promptbox = awful.widget.prompt
--require('wiboxes.promptboxes')
local keys = awful.util.table.join({}
  , awful.key({ modkey }, 'r', function () promptbox[mouse.screen]:run() end)
  , awful.key({ modkey }, 'x', function ()
      awful.prompt.run( { prompt = 'Run Lua code: ' }
                      , promptbox[mouse.screen].widget
                      , awful.util.eval
                      , nil
                      , awful.util.getdir('cache') .. '/history_eval'
                      )
    end)
  , require('bindings.global.prompt.pass').keys
  )

return { keys = keys }
