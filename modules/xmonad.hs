{-# LANGUAGE NamedFieldPuns #-}
-- Base
import XMonad hiding (Color, whenJust)
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.CycleWS (nextWS, prevWS, shiftToNext, shiftToPrev)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

   -- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe, seconds)
import XMonad.Util.SpawnOnce
import XMonad.Util.Types
import XMonad.Prompt
import XMonad.Prompt.Shell

   -- which key libs
import XMonad.Util.Font (Align(..))
import XMonad.Actions.Submap (submap)
import Relude as R hiding ((??))
import Relude.Extra.Foldable1
import Relude.Extra.Tuple
import Relude.Extra.Bifunctor
--type unlines = R.unlines

import Text.Printf
import Data.Text.Format (Only(..))
import qualified Data.Text.Format as F
import XMonad.Util.EZConfig (mkKeymap, checkKeymap)
import System.Posix.IO
import System.Posix.Types (CPid(..))
import System.Process (system, readProcess)
import System.Posix.Process (executeFile, getProcessID)
import System.Posix.Signals (signalProcess, sigKILL)
import Control.Concurrent (threadDelay)

wrap2 :: Text -> Text -> Text -> Text
wrap2 left right middle = left <> middle <> right

pad2 :: Text -> Text
pad2 = wrap2 (T.pack " ") (T.pack " ")

shorten2 :: Int -> Text -> Text
shorten2 maxlen text = case text `T.compareLength` maxlen of
  GT -> T.snoc (T.take maxlen text) ellipsis
  otherwise -> text
  where ellipsis = '…'

format2 fmt = TL.toStrict . F.format fmt
format1 str item = format2 str (Only item)

mapThd3 f (a,b,c) = (a,b, f c)
dropSnd3 (a,b,c) = (a,c)
dropThd3 (a,b,c) = (a,b)

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=11:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "terminator"    -- Sets default terminal

myBrowser :: String
myBrowser = "chromium"  -- Sets qutebrowser as browser

--myEmacs :: String
--myEmacs = "emacsclient -c -a 'emacs' "  -- Makes emacs keybindings easier to type

--myEditor :: String
--myEditor = "emacsclient -c -a 'emacs' "  -- Sets emacs as editor
-- myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 2           -- Sets border width for windows

myNormColor :: String
myNormColor   = "#282c34"   -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#46d9ff"   -- Border color of focused windows

windowCount :: X (Maybe String)
windowCount = gets $ Just . R.show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- Dzen config options
type Color = Text

dzenFg, dzenBg :: Color -> Text -> Text
dzenFg color string = format2 (R.show "^fg({}){}^fg()") (color, string)
dzenBg color string = format2 (R.show "^bg({}){}^bg()") (color, string)

myStartupHook :: X ()
myStartupHook = do
    --spawnOnce "picom &"
    spawnOnce "nm-applet &"
    spawnOnce "volumeicon &"
    --spawnOnce "conky -c $HOME/.config/conky/xmonad.conkyrc"
    spawnOnce "trayer --edge bottom --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 22 &"
    spawnOnce "kak -d -s mysession &"  -- kakoune daemon for better performance
    spawnOnce "feh --randomize --bg-fill /etc/nixos/modules/wallpapers/*"  -- feh set random wallpaper
    setWMName "LG3D"

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "calculator" spawnCalc findCalc manageCalc
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 3
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 3
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 3
           $ spiral (6/7)

tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
tallAccordion  = renamed [Replace "tallAccordion"]
           $ Accordion
wideAccordion  = renamed [Replace "wideAccordion"]
           $ Mirror Accordion

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| spirals
                                 ||| tallAccordion
                                 ||| wideAccordion

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
-- myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
myWorkspaces = ["main", "dev", "www", "doc", "http", "chat", "mus", "git", "nix"]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++ R.show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
     [ className =? "confirm"         --> doFloat
     , className =? "file_progress"   --> doFloat
     , className =? "dialog"          --> doFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "Gimp"            --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     , title =? "Oracle VM VirtualBox Manager"  --> doFloat
     , title =? "Mozilla Firefox"     --> doShift ( myWorkspaces !! 1 )
     , className =? "brave-browser"   --> doShift ( myWorkspaces !! 1 )
     , className =? "qutebrowser"     --> doShift ( myWorkspaces !! 1 )
     , className =? "mpv"             --> doShift ( myWorkspaces !! 7 )
     , className =? "Gimp"            --> doShift ( myWorkspaces !! 8 )
     , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     , isFullscreen -->  doFullFloat
     ] <+> namedScratchpadManageHook myScratchPads
-- prompt style
myXPConfig = def
  { position          = Bottom
  , alwaysHighlight   = True
--  , promptBorderWidth = 2
  , font              = "xft:monospace:size=9"
  , borderColor       = myFocusColor
  }
-- which keys helper function
spawnKeymap :: Text -> [(Text, Text, String)] -> (String, X ())
spawnKeymap key items = (toString key, whichkeySubmap def myConfig $ mapThd3 spawn <$> items)

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-S-r", spawn "xmonad --recompile")  -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")    -- Restarts xmonad
        , ("M-S-q", io System.Exit.exitSuccess)              -- Quits xmonad

    -- Run Prompt
        , ("M-r", shellPrompt myXPConfig)
 --       , ("M-S-<Return>", spawn "dmenu_run -i -p \"Run: \"") -- Dmenu

    -- Other Dmenu Prompts
    -- In Xmonad and many tiling window managers, M-p is the default keybinding to
    -- launch dmenu_run, so I've decided to use M-p plus KEY for these dmenu scripts.
--        , ("M-p a", spawn "dm-sounds")    -- choose an ambient background
--        , ("M-p b", spawn "dm-setbg")     -- set a background
--        , ("M-p c", spawn "dm-colpick")   -- pick color from our scheme
--        , ("M-p e", spawn "dm-confedit")  -- edit config files
--        , ("M-p i", spawn "dm-maim")      -- screenshots (images)
--        , ("M-p k", spawn "dm-kill")      -- kill processes
--        , ("M-p m", spawn "dm-man")       -- manpages
--        , ("M-p o", spawn "dm-bookman")   -- qutebrowser bookmarks/history
--        , ("M-p p", spawn "passmenu")     -- passmenu
--        , ("M-p q", spawn "dm-logout")    -- logout menu
--        , ("M-p r", spawn "dm-reddit")    -- reddio (a reddit viewer)
--        , ("M-p s", spawn "dm-websearch") -- search various search engines

    -- Useful programs to have a keybinding for launch
        , ("M-<Return>", spawn (myTerminal))
        , ("M-t", spawn ("alacritty"))
        , ("M-S-t", spawn ("alacritty"))
         -- cant combine spawnando and normal code, so we just add a command
         -- one key away
        , ("M-S-y", withFocused (sendMessage . mergeDir W.focusUp'))
        , ("M-S-<Return>", spawn ("alacritty"))
        , ("M-w", spawn (myBrowser ++ " www.google.com"))
        , ("M-M1-h", spawn (myTerminal ++ " -e htop"))

    -- Kill windows
        , ("M-S-c", kill1)     -- Kill the currently focused client
        , ("M-S-a", killAll)   -- Kill all windows on current workspace

    -- Workspaces
        , ("M-<Right>", nextWS)  -- Switch focus to next monitor
        , ("M-<Left>", prevWS)  -- Switch focus to prev monitor
        , ("M-S-<Right>", shiftToNext >> nextWS)       -- Shifts focused window to next ws
        , ("M-S-<Left>", shiftToPrev >> prevWS)  -- Shifts focused window to prev ws

    -- Floating windows
--        , ("M-<Space> f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
--        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
--        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- Increase/decrease spacing (gaps)
        , ("C-M1-j", decWindowSpacing 4)         -- Decrease window spacing
        , ("C-M1-k", incWindowSpacing 4)         -- Increase window spacing
        , ("C-M1-h", decScreenSpacing 4)         -- Decrease screen spacing
        , ("C-M1-l", incScreenSpacing 4)         -- Increase screen spacing

    -- Grid Select (CTR-g followed by a key)
--        , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
        , ("M-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("M-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

    -- Windows navigation
        , ("M-m m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-<Tab>", windows W.focusDown)    -- Move focus to the next window
        , ("M-S-<Tab>", windows W.focusUp)      -- Move focus to the prev window
        , ("M-<Up>", windows W.focusDown)    -- Move focus to the next window
        , ("M-<Down>", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
    --    , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
    --    , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- Layouts
        , ("M-<Space>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

    -- Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
        , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
        , ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows

    -- Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-M1-k", sendMessage MirrorExpand)          -- Expand vert window width

    -- Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        , ("M-C-h", withFocused (sendMessage . UnMerge))
        , ("M-C-l", withFocused (sendMessage . UnMerge))
        , ("M-C-k", withFocused (sendMessage . mergeDir W.focusDown'))
        , ("M-C-j", withFocused (sendMessage . mergeDir W.focusUp'))
        , ("M-C-m", withFocused (sendMessage . MergeAll))
        , ("M-C-u", withFocused (sendMessage . UnMerge))
        , ("M-C-/", withFocused (sendMessage . UnMergeAll))
        , ("M-C-.", onGroup W.focusUp')    -- Switch focus to next tab
        , ("M-C-,", onGroup W.focusDown')  -- Switch focus to prev tab

    -- Scratchpads
    -- Toggle show/hide these programs.  They run on a hidden workspace.
    -- When you toggle them to show, it brings them to your current workspace.
    -- Toggle them to hide and it sends them back to hidden workspace (NSP).
        , ("C-s t", namedScratchpadAction myScratchPads "terminal")
    --    , ("C-s c", namedScratchpadAction myScratchPads "calculator")

    -- Set wallpaper with 'feh'. Type 'SUPER+F1' to launch sxiv in the wallpapers directory.
    -- Then in sxiv, type 'C-x w' to set the wallpaper that you choose.
        , ("M-<F1>", spawn "sxiv -r -q -t -o ~/wallpapers/*")
        , ("M-<F2>", spawn "/bin/ls ~/wallpapers | shuf -n 1 | xargs xwallpaper --stretch")
        --, ("M-<F2>", spawn "feh --randomize --bg-fill ~/wallpapers/*")

    -- Controls for spotify music player (SUPER-u followed by a key)
        , ("M-M1-<Up>", spawn "spotify")
        , ("M-M1-<Down>", spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause")
        , ("M-M1-<Left>", spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous")
        , ("M-M1-<Right>", spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next")

    -- Xbacklight keys
        , ("<XF86MonBrightnessDown>", spawn "/run/current-system/sw/bin/xbacklight -dec 10")
        , ("S-<XF86MonBrightnessDown>", spawn "/run/current-system/sw/bin/xbacklight -dec 1")
        , ("<XF86MonBrightnessUp>", spawn "/run/current-system/sw/bin/xbacklight -inc 10")
        , ("S-<XF86MonBrightnessUp>", spawn "/run/current-system/sw/bin/xbacklight -inc 1")
        -- map to F keys also
        , ("M-<F5>", spawn "/run/current-system/sw/bin/xbacklight -dec 10")
        , ("M-S-<F5>", spawn "/run/current-system/sw/bin/xbacklight -dec 1")
        , ("M-<F6>", spawn "/run/current-system/sw/bin/xbacklight -inc 10")
        , ("M-S-<F6>", spawn "/run/current-system/sw/bin/xbacklight -inc 1")

       -- Multimedia Keys
        , ("<XF86AudioMute>", spawn "amixer set Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 10%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 10%+ unmute")
       -- multiply with shift
        , ("S-<XF86AudioLowerVolume>", spawn "amixer set Master 2%- unmute")
        , ("S-<XF86AudioRaiseVolume>", spawn "amixer set Master 2%+ unmute")
        , ("M-<Print>", spawn "scrot")
        ]
    -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

myInfoKeys = return $ spawnKeymap (T.pack "M-i") info
 where
  info = [ ((T.pack "i") ,(T.pack "test"), (R.show ""))

         ]
allMyKeys :: [(String, X ())]
allMyKeys = concat
 [myKeys, myInfoKeys]

myKeymap = flip mkKeymap myKeys

myConfig = def
  { terminal        = myTerminal
  , modMask         = myModMask
  , keys            = myKeymap
  , startupHook     = myStartupHook
  , workspaces      = myWorkspaces
  , layoutHook      = myLayoutHook
  }

-- which-key helper
displayTextFont :: String
displayTextFont = "Iosevka:pixelsize=15"

displayTextSync :: MonadIO m => Maybe Int -> Text -> m ()
displayTextSync time text = io . void $ readProcess "dzen2"
  (("-p" : timeArg) ++
   [ "-l", R.show numLines
   , "-ta", "c" , "-sa", "c"
   , "-e", "onstart=uncollapse"                 -- show all lines at startup (by default they only show on mouse hover)
   , "-fn", displayTextFont
   ])
  (toString text)
  where
    numLines = max 0 (length (R.lines text) - 1)  -- we only count slave lines, so everything after the first one
    timeArg = maybeToList $ R.show <$> time

displayText time text = void $ xfork $ displayTextSync time text

displayTextSyncTill, displayTextTill :: MonadIO m => Int -> Text -> m ()
displayTextSyncTill = displayTextSync . Just
displayTextTill = displayText . Just

displayTextSyncForever, displayTextForever :: MonadIO m => Text -> m ()
displayTextSyncForever = displayTextSync Nothing
displayTextForever = displayText Nothing

data WhichkeyConfig
  = WhichkeyConfig
  { keyFg  :: Color     -- ^ foreground color for keys
  , descFg :: Color     -- ^ foreground color for action descriptions
  , delay  :: Rational  -- ^ delay (in seconds) after which whichkey pops up
  }

instance Default WhichkeyConfig where
  def = WhichkeyConfig
    { keyFg  = T.pack "#61afef"
    , descFg = T.pack "#98c379"
    , delay  = 1.5
    }

whichkeyShowBindings :: WhichkeyConfig -> [(Text, Text, X ())] -> [Text]
whichkeyShowBindings WhichkeyConfig{keyFg, descFg} keybinds =
  keybinds
  <&> dropThd3
  <&> first capitalizeIfShift
   &  unzip
   &  bimap equalizeLeft equalizeRight
   &  uncurry zip
  <&> bimap (dzenFg keyFg) (dzenFg descFg)
  <&> format2 (R.show "{} -> {}")
  where
    capitalizeIfShift keystr
      | (T.pack "S-") `T.isPrefixOf` last3 = T.snoc (T.dropEnd 3 keystr) (toUpper lastChar)
      | otherwise = keystr
      where
        last3 = T.takeEnd 3 keystr
        lastChar = T.last last3

    equalizeLeft keys =
      let maxLen = maximum1 (T.length <$> T.empty :| keys) in
      T.justifyRight maxLen ' ' <$> keys

    equalizeRight descriptions =
      let maxLen = maximum1 (T.length <$> T.empty :| descriptions) in
      T.justifyLeft maxLen ' ' <$> descriptions

whichkeySubmap :: WhichkeyConfig
               -> XConfig l
               -> [(Text, Text, X ())]
               -> X ()
whichkeySubmap whichkeyConf config keybinds = do
  pid <- xfork (threadDelay (seconds $ delay whichkeyConf) >> displayTextSyncForever (toHelp keybinds))
  catchX (submap . mkKeymap config $ first toString . dropSnd3 <$> keybinds) mempty
  io $ signalProcess sigKILL pid
  spawn "pkill dzen2"
  where
    toHelp = R.unlines . whichkeyShowBindings whichkeyConf

main :: IO ()
main = do
    -- Launching three instances of xmobar on their monitors.
    xmproc0 <- spawnPipe "xmobar -x 0 /etc/nixos/modules/xmobar/xmobarrc0"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh def
        { manageHook         = myManageHook <+> manageDocks
        , handleEventHook    = docksEventHook
                               -- Uncomment this line to enable fullscreen support on things like YouTube/Netflix.
                               -- This works perfect on SINGLE monitor systems. On multi-monitor systems,
                               -- it adds a border around the window if screen does not have focus. So, my solution
                               -- is to use a keybinding to toggle fullscreen noborders instead.  (M-<Space>)
                               -- <+> fullscreenEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
              -- the following variables beginning with 'pp' are settings for xmobar.
              { ppOutput = \x -> hPutStrLn xmproc0 x                          -- xmobar on monitor 1
              , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"           -- Current workspace
              , ppVisible = xmobarColor "#98be65" "" . clickable              -- Visible but not current workspace
              , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" "" . clickable -- Hidden workspaces
              , ppHiddenNoWindows = xmobarColor "#c792ea" ""  .wrap " " " ". clickable     -- Hidden workspaces (no windows)
              , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
              , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
              , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
              , ppExtras  = [windowCount]                                     -- # of windows current workspace
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
              }
        } `additionalKeysP` myKeys
