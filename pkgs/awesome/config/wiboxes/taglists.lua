local awful = require('awful')
local buttons = require('bindings.global.tags').buttons

awful.screen.connect_for_each_screen(function(s)
  s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, buttons)
end)

return true
