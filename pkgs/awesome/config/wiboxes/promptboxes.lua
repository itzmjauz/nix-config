local awful = require('awful')

local promptboxes = {}
for s = 1, screen.count() do
  promptboxes[s] = awful.widget.prompt()
end

return promptboxes
