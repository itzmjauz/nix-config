local naughty = require('naughty')

local in_error = false
awesome.connect_signal('debug::error', function (err)
  -- Prevent infinite recursion
  if in_error then return end
  in_error = true

  naughty.notify({ preset = naughty.config.presets.critical
                 , title = 'Oops, an error happened!'
                 , text = err
                 })
  in_error = false
end)
