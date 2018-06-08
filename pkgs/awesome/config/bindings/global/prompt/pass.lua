local awful = require('awful')

local prefs = require('preferences')
local modkey = prefs.modkey

local keys = awful.util.table.join({}
  , awful.key({ modkey }, 'p', function ()
      awful.prompt.run( { prompt = 'pass ' }
                      , awful.screen.focused().mypromptbox.widget
                      , function (pass)
                          awful.util.spawn('pass -c ' .. pass)
                        end
                      , nil
                      , awful.util.getdir('cache') .. '/history_pass'
                      )
    end)
  )

return { keys = keys }
