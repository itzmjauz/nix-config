  -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn, Handle)
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
import XMonad.Actions.CycleWS (nextWS, prevWS, shiftToNext, shiftToPrev, toggleOrDoSkip)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
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
import XMonad.Util.EZConfig (additionalKeysP, mkKeymap, additionalKeys)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.Ungrab
import XMonad.Prompt
import XMonad.Prompt.Shell
import qualified Data.List as L
import qualified Data.Text as T
import qualified Data.Map as M
import Data.List.Split

--solarized colors
base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green   = "#859900"
black   = "#000000"

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
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

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
myShowWNameTheme = def  { swn_font              = "xft:Ubuntu:bold:size=60"
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

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
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
myXPConfig = def {  position          = Bottom
                  , alwaysHighlight   = True
                --  , promptBorderWidth = 2
                  , font              = "xft:monospace:size=9"
                  , borderColor       = myFocusColor
                 }

myKeys :: XConfig l -> [(String, X (), String)]
myKeys c =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile", "Recompile XMonad")  -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart", "Restart XMonad")    -- Restarts xmonad
        , ("M-S-q", io exitSuccess, "Quit XMonad")              -- Quits xmonad

    -- Run Prompt
        , ("M-r", shellPrompt myXPConfig, "Open shell prompt")
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
        , ("M-<Return>",   spawn (myTerminal),      "Spawn terminator")
        , ("M-t",          spawn ("alacritty"),     "Spawn alacritty")
        , ("M-S-t",        spawn ("alacritty"),     "Spawn alacritty")
         -- cant combine spawnando and normal code, so we just add a command
         -- one key away
        , ("M-S-y",        withFocused (sendMessage . mergeDir W.focusUp'), "Merge w -> tabs")
        , ("M-S-u",        withFocused (sendMessage . UnMerge),             "Unmerge w")
        , ("M-S-<Return>", spawn ("alacritty"),                             "Spawn alacritty")
        , ("M-w",          spawn (myBrowser ++ " www.google.com"),          "Spawn chromium")
        , ("M-M1-h",       spawn (myTerminal ++ " -e htop"),                "Spawn htop")

    -- Kill windows
        , ("M-S-c",        kill1,   "Kill window")     -- Kill the currently focused client
        , ("M-S-a",        killAll, "Kill all w in ws")   -- Kill all windows on current workspace

    -- Workspaces
        , ("M-<Right>",     nextWS,                 "Cycle ws ->")  -- Switch focus to next monitor
        , ("M-<Left>",      prevWS,                 "Cycle ws <-")  -- Switch focus to prev monitor
        , ("M-S-<Right>",   shiftToNext >> nextWS,  "move w to ws ->")       -- Shifts focused window to next ws
        , ("M-S-<Left>",    shiftToPrev >> prevWS,  "move w to ws <-")  -- Shifts focused window to prev ws

    -- Floating windows
--        , ("M-<Space> f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
--        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
--        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- Increase/decrease spacing (gaps)
        , ("C-M1-j", decWindowSpacing 4, "Window spacing -")         -- Decrease window spacing
        , ("C-M1-k", incWindowSpacing 4, "Window spacing +")         -- Increase window spacing
        , ("C-M1-h", decScreenSpacing 4, "Screen spacing -")         -- Decrease screen spacing
        , ("C-M1-l", incScreenSpacing 4, "Screen spacing +")         -- Increase screen spacing

    -- Grid Select (CTR-g followed by a key)
--        , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
        , ("M-g t", goToSelected $ mygridConfig myColorizer,  "Goto w")  -- goto selected window
        , ("M-g b", bringSelected $ mygridConfig myColorizer, "Bring w") -- bring selected window

    -- Windows navigation
        , ("M-m m",         windows W.focusMaster,  "Goto Master w")  -- Move focus to the master window
        , ("M-<Tab>",       windows W.focusDown,    "Cycle w")    -- Move focus to the next window
        , ("M-S-<Tab>",     windows W.focusUp,      "Cycle w rev")      -- Move focus to the prev window
        , ("M-<Up>",        windows W.focusDown,    "Cycle w")    -- Move focus to the next window
        , ("M-<Down>",      windows W.focusUp,      "Cycle w rev")      -- Move focus to the prev window
        , ("M-S-m",         windows W.swapMaster,   "w = master") -- Swap the focused window and the master window
        , ("M-S-j",         windows W.swapDown,     "Swap w ->")   -- Swap focused window with next window
        , ("M-S-k",         windows W.swapUp,       "Swap w <-")     -- Swap focused window with prev window
        , ("M-<Backspace>", promote,                "Promote w")      -- Moves focused window to master, others maintain order
    --    , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
    --    , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- Layouts
        , ("M-<Space>", sendMessage NextLayout,                                     "Cycle layouts")           -- Switch to next layout
        , ("M-f",       sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts, "Toggle fullscreen") -- Toggles noborder/full

    -- Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>",      sendMessage (IncMasterN 1),     "Increase # clients")      -- Increase # of clients master pane
        , ("M-S-<Down>",    sendMessage (IncMasterN (-1)),  "Decrease # clients") -- Decrease # of clients master pane
        , ("M-C-<Up>",      increaseLimit,                  "Increase # w")                   -- Increase # of windows
        , ("M-C-<Down>",    decreaseLimit,                  "Decrease # w")                 -- Decrease # of windows

    -- Window resizing
        , ("M-h",           sendMessage Shrink,             "Shrink window <->")                   -- Shrink horiz window width
        , ("M-l",           sendMessage Expand,             "Expand window <->")                   -- Expand horiz window width
        , ("M-M1-j",        sendMessage MirrorShrink,       "Shrink window ^-v")          -- Shrink vert window width
        , ("M-M1-k",        sendMessage MirrorExpand,       "Expand window ^-v")          -- Expand vert window width

    -- Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        , ("M-C-h", withFocused (sendMessage . UnMerge),                "Unmerge w")
        , ("M-C-l", withFocused (sendMessage . UnMerge),                "Unmerge w")
        , ("M-C-k", withFocused (sendMessage . mergeDir W.focusDown'),  "Merge w ->")
        , ("M-C-j", withFocused (sendMessage . mergeDir W.focusUp'),    "Merge w <-")
        , ("M-C-m", withFocused (sendMessage . MergeAll),               "Merge all w")
        , ("M-C-u", withFocused (sendMessage . UnMerge),                "Unmerge w")
        , ("M-C-/", withFocused (sendMessage . UnMergeAll),             "Unmerge all w")
        , ("M-C-.", onGroup W.focusUp',                                 "Cycle w ->")    -- Switch focus to next tab
        , ("M-C-,", onGroup W.focusDown',                               "Cycle w <-")  -- Switch focus to prev tab

    -- Scratchpads
    -- Toggle show/hide these programs.  They run on a hidden workspace.
    -- When you toggle them to show, it brings them to your current workspace.
    -- Toggle them to hide and it sends them back to hidden workspace (NSP).
        , ("C-s t", namedScratchpadAction myScratchPads "terminal", "terminal sp")
    --    , ("C-s c", namedScratchpadAction myScratchPads "calculator")

    -- Set wallpaper with 'feh'. Type 'SUPER+F1' to launch sxiv in the wallpapers directory.
    -- Then in sxiv, type 'C-x w' to set the wallpaper that you choose.
--        , ("M-<F1>", spawn "sxiv -r -q -t -o ~/wallpapers/*")
--        , ("M-<F2>", spawn "/bin/ls ~/wallpapers | shuf -n 1 | xargs xwallpaper --stretch")
        --, ("M-<F2>", spawn "feh --randomize --bg-fill ~/wallpapers/*")

    -- Controls for spotify music player (SUPER-u followed by a key)
        , ("M-M1-<Up>",     spawn "spotify", "Launch spotify")
        , ("M-M1-<Down>",   spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause", "Pause spot")
        , ("M-M1-<Left>",   spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous", "Prev song")
        , ("M-M1-<Right>",  spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next", "Next song")

    -- Xbacklight keys
        , ("<XF86MonBrightnessDown>",   spawn "/run/current-system/sw/bin/xbacklight -dec 10", "Brightness -10%")
        , ("S-<XF86MonBrightnessDown>", spawn "/run/current-system/sw/bin/xbacklight -dec 1", "Brightness -1%")
        , ("<XF86MonBrightnessUp>",     spawn "/run/current-system/sw/bin/xbacklight -inc 10", "Brightness +10%")
        , ("S-<XF86MonBrightnessUp>",   spawn "/run/current-system/sw/bin/xbacklight -inc 1", "Brightness +1%")
        -- map to F keys also
        , ("M-<F5>",   spawn "/run/current-system/sw/bin/xbacklight -dec 10", "Brightness -10%")
        , ("M-S-<F5>", spawn "/run/current-system/sw/bin/xbacklight -dec 1",  "Brightness -1%")
        , ("M-<F6>",   spawn "/run/current-system/sw/bin/xbacklight -inc 10", "Brightness +10%")
        , ("M-S-<F6>", spawn "/run/current-system/sw/bin/xbacklight -inc 1",  "Brightness +1%")

       -- Multimedia Keys
        , ("<XF86AudioMute>",        spawn "amixer set Master toggle",      "Toggle mute")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 10%- unmute", "Volume -10%")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 10%+ unmute", "Volume +10%")
       -- multiply with shift
        , ("S-<XF86AudioLowerVolume>", spawn "amixer set Master 2%- unmute", "Volume -2%")
        , ("S-<XF86AudioRaiseVolume>", spawn "amixer set Master 2%+ unmute", "Volume +2%")
        , ("M-<Print>",                spawn "scrot",                        "Printscreen")
        , ("M-<F1>",                   unGrab >> showHelp,                   "Show Help")
        ]
        where
            showHelp = spawn $ unwords [ "/etc/nixos/modules/xmobar/showHintForKeymap.sh"
                                , desc
                                , "dzen_xmonad"
                                , show (30 :: Integer)
                                , show (0 :: Integer)
                                , show black
                                , show (1 :: Integer)
                                ]
            desc = fmtDesc "Help" (myKeys c) 14 base1 green
-- display key information
keyMapDoc :: String -> String -> String -> Int -> X Handle
keyMapDoc desc id color delay = do
  -- focused screen location/size
    handle <- spawnPipe $ unwords [ "/etc/nixos/modules/xmobar/showHintForKeymap.sh"
                                  , desc
                                  , id
                                  , "22"
                                  , show delay
                                  , show color
                                  , show 0
                                  ]
    return handle

rmDesc :: [(a,b,c)] -> [(a,b)]
rmDesc x = [(t1,t2) | (t1,t2,_) <- x]

fmtDesc :: String -> [(String, a, String)] -> Int -> String -> String -> String
fmtDesc name map rows fg hl | name == "" = "'" ++ "\\n" ++ list ++ "'"
                            | otherwise  = "'" ++ colStr hl ++ name ++ "\\n\\n" ++ list ++ "'"
    where
        list = L.intercalate "\\n" (foldr (zipWithMore (++)) [""] col)
        col = chunksOf nRows $ colDesc map
        --sortKeys  = L.sortBy (\(a,_,_) (b,_,_) -> compare a b)
        maxChars = 200
        lMap = length map
        nRows = min rows lMap
        nCol = max 1 $ ceiling $ fromIntegral lMap / fromIntegral nRows
        charsPerCol = quot maxChars nCol
        charsPerICol = quot charsPerCol 2

        descAlign = charsPerICol
        keyAlign = charsPerICol

        colDesc :: [(String, a, String)] -> [String]
        colDesc x = [ colStr hl ++ rAlign keyAlign key ++ " " ++ colStr fg ++ lAlign descAlign desc | (key,_,desc) <- x]

        colStr :: String -> String
        colStr col = "^fg(" ++ col ++ ")"

        rAlign :: Int -> String -> String
        rAlign = textAlign T.justifyRight

        lAlign :: Int -> String -> String
        lAlign = textAlign T.justifyLeft

        textAlign :: (Int -> Char -> T.Text -> T.Text) -> Int -> (String -> String)
        textAlign fAlign n = T.unpack . (fAlign n ' ') . T.pack

        zipWithMore :: (a -> a -> a) -> [a] -> [a] -> [a]
        zipWithMore f (a:as) (b:bs) = f a b : zipWithMore f as bs
        zipWithMore _ []      bs    = bs -- if there's more in bs, use that
        zipWithMore _ as      []    = as -- if there's more in as, use that

myWorkspaceKeys :: [((KeyMask, KeySym), X())]
myWorkspaceKeys = [((m .|. myModMask, k), f i)
        | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
        , (f, m) <- [(myToggleOrView, 0), (windows . W.shift, shiftMask)]]
            where
                myToggleOrView = toggleOrDoSkip [] W.view

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
        , keys               = \c -> mkKeymap c $ rmDesc (myKeys c)
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
        }`additionalKeys` myWorkspaceKeys
