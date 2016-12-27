local awful = require('awful')
local buttons = require('bindings.global.tags').buttons

local taglists = {}
for s = 1, screen.count() do
  taglists[s] = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, buttons)
end

return taglists 
