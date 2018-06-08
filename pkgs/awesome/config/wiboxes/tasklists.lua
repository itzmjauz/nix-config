local awful = require('awful')
local buttons = require('bindings.global.tasks').buttons

awful.screen.connect_for_each_screen(function(s)
  s.tasklists = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, buttons)
end)

return true

