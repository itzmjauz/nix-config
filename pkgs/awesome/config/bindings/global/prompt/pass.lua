local awful = require('awful')

local prefs = require('preferences')
local modkey = prefs.modkey

local promptbox = require('wiboxes.promptboxes')
local keys = awful.util.table.join({}
  , awful.key({ modkey }, 'p', function ()
      awful.prompt.run( { prompt = 'pass ' }
                      , promptbox[mouse.screen].widget
                      , function (pass)
                          awful.util.spawn('pass -c ' .. pass)
                        end
                      , nil
                      , awful.util.getdir('cache') .. '/history_pass'
                      )
    end)
  )

return { keys = keys }
