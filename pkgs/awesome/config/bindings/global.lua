local awful = require('awful')

local prefs = require('preferences')
local modkey = prefs.modkey

local keys = awful.util.table.join({}
  , awful.key({ modkey, 'Control' }, 'r', awesome.restart)
  , awful.key({ modkey, 'Shift'   }, 'q', awesome.quit)
  , require('bindings.global.tags').keys
  , require('bindings.global.tasks').keys
  , require('bindings.global.layout').keys
  , require('bindings.global.programs').keys
  , require('bindings.global.prompt').keys
  , require('bindings.global.audiokeys').keys
  , require('bindings.global.keyboard').keys
  , require('bindings.global.lightkeys').keys
  )

return { keys = keys }
