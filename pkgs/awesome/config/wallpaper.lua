local wallpaper = require('beautiful').wallpaper
if not wallpaper then return end
local gears = require('gears')

for s = 1, screen.count() do
  if wallpaper:sub(0, 1) == '#' then
    gears.wallpaper.set(wallpaper)
  else
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end
