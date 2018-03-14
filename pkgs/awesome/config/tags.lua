local awful = require('awful')
local layouts = require('layouts')

tags = {}
for s = 1, screen.count() do
  -- Each screen has its own tag table.
  tags[s] = awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8', '9', 'h'}, s, layouts[1])
end

return tags
