local awful = require('awful')
awful.rules = require('awful.rules')
local beautiful = require('beautiful')

require('awful.autofocus')
awful.rules.rules = { { rule = { }
                      , properties = { border_width = beautiful.border_width
                                     , border_color = beautiful.border_normal
                                     , size_hints_honor = false
                                     , focus = awful.client.focus.filter
                                     , keys = require('bindings.client').keys
                                     , buttons = require('bindings.client').buttons
                                     , raise = true
                                     , screen = awful.screen.preferred
                                     , placement = awful.placement.no_overlap+awful.placement.no_offscreen
                                     }
                      }
                    , { rule = { class = 'MPlayer' }
                      , properties = { floating = true }
                      }
                    , { rule = { class = 'pinentry' }
                      , properties = { floating = true }
                      }
                    , { rule = { class = 'gimp' }
                      , properties = { floating = true }
                      }
                }

client.connect_signal('focus', function(c) c.border_color = beautiful.border_focus end)
client.connect_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)

client.connect_signal('manage', function (c, startup)
  c:connect_signal('mouse::enter', function(c)
    -- sloppy focus
      if awful.client.focus.filter(c) then client.focus = c end
  end)

  if not startup then
    if not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.no_overlap(c)
      awful.placement.no_offscreen(c)
    end
  end
end)

