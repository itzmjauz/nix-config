local awful = require('awful')
local buttons = require('bindings.global.tasks').buttons

local tasklists = {}
for s = 1, screen.count() do
  tasklists[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, buttons)
end

return tasklists
