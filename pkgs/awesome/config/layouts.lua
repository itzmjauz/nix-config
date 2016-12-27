local awful = require('awful')
return { awful.layout.suit.tile
       , awful.layout.suit.tile.left
       , awful.layout.suit.tile.bottom
       , awful.layout.suit.tile.top
       , awful.layout.suit.fair
       , awful.layout.suit.fair.horizontal
       , awful.layout.suit.max.fullscreen
       }
