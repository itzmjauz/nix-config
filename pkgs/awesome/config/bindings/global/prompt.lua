local awful = require('awful')

local prefs = require('preferences')
local modkey = prefs.modkey

local promptbox = awful.widget.prompt
--require('wiboxes.promptboxes')
local keys = awful.util.table.join({}
  , awful.key({ modkey }, 'r', function ()
      awful.prompt.run( { prompt = '/bin/sh: ' }
                      , awful.screen.focused().mypromptbox.widget
                      , function (shellcmd)
                          awful.spawn.with_line_callback(shellcmd, {
                            stderr = function(line)
                              naughty.notify {text="ERR:\n"..line}
                            end
                          })
                        end
                      , nil
                      , awful.util.getdir('cache') .. '/history'
                      )
      end)

  , awful.key({ modkey }, 'x', function ()
      awful.prompt.run( { prompt = 'Run Lua code: ' }
                      , awful.screen.focused().mypromptbox.widget
                      , awful.util.eval
                      , nil
                      , awful.util.getdir('cache') .. '/history_eval'
                      )
    end)
  , require('bindings.global.prompt.pass').keys
  )

return { keys = keys }
