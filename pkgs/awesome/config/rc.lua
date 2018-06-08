require('errorhandler')
require('beautiful').init('@out@/etc/xdg/awesome/theme.lua')

require('rules')
root.keys(require('bindings.global').keys)

require('wiboxes')

do
  local awful = require('awful')
  awful.spawn('wmname LG3D')
  awful.spawn(os.getenv('HOME') .. '/.configs/autostart')
end
