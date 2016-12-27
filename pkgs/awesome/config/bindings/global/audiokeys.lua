local awful = require('awful')
local naughty = require('naughty')

local prefs = require('preferences')
local modkey = prefs.modkey

function say(text) naughty.notify({ text = text }) end
function sayShell(cmd) say(awful.util.pread(cmd)) end

local keys = awful.util.table.join({}
  ,    awful.key({ }, "XF86AudioMute",         function () sayShell('/run/current-system/sw/bin/amixer set Master togglemute') end)
  ,    awful.key({ }, "XF86Tools",             function () sayShell('/run/current-system/sw/bin/amixer set Master unmute') end)
  ,    awful.key({ }, "XF86AudioRaiseVolume",  function () sayShell('/run/current-system/sw/bin/amixer set Master 10%+')  end)
  ,    awful.key({'Shift'}, "XF86AudioRaiseVolume",  function () sayShell('/run/current-system/sw/bin/amixer set Master 1%+')  end)
  ,    awful.key({}, "XF86AudioLowerVolume",  function () sayShell('/run/current-system/sw/bin/amixer set Master 10%-') end)
  ,    awful.key({'Shift'}, "XF86AudioLowerVolume",  function () sayShell('/run/current-system/sw/bin/amixer set Master 1%-') end)

  ,    awful.key({ modkey }, "F8",         function () sayShell('/run/current-system/sw/bin/amixer set Master togglemute') end)
  ,    awful.key({ modkey }, "F10",  function () sayShell('/run/current-system/sw/bin/amixer set Master 10%+')  end)
  ,    awful.key({ modkey, 'Shift'}, "F10",  function () sayShell('/run/current-system/sw/bin/amixer set Master 1%+')  end)
  ,    awful.key({ modkey }, "F9",  function () sayShell('/run/current-system/sw/bin/amixer set Master 10%-') end)
  ,    awful.key({ modkey, 'Shift'}, "F9",  function () sayShell('/run/current-system/sw/bin/amixer set Master 1%-') end)

  ,    awful.key({ modkey, 'Mod1' }, "F8",         function () awful.util.spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause') end)
  ,    awful.key({ modkey, 'Mod1' }, "F9",         function () awful.util.spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous') end)
  ,    awful.key({ modkey, 'Mod1' }, "F10",         function () awful.util.spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next') end)

  ,    awful.key({ 'Mod1' }, "XF86AudioMute",         function () awful.util.spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause') end)
  ,    awful.key({ 'Mod1' }, "XF86AudioLowerVolume",         function () awful.util.spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous') end)
  ,    awful.key({ 'Mod1' }, "XF86AudioRaiseVolume",         function () awful.util.spawn('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next') end)

)
return { keys = keys }
