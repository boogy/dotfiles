import qualified Data.Map as M
import Data.Monoid
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Layout.IndependentScreens
import XMonad.Layout.NoBorders
import XMonad.Layout.WindowNavigation
import qualified XMonad.StackSet as W
import XMonad.Util.Run (spawnPipe)

myTerminal = "st"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
myModMask = mod4Mask

-- The keys on my number row.
myNumRow =
  [ xK_ampersand
  , xK_bracketleft
  , xK_braceleft
  , xK_braceright
  , xK_parenleft
  , xK_equal
  , xK_asterisk
  , xK_parenright
  , xK_plus
  ]

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor = "#dddddd"

myFocusedBorderColor = "#ff0000"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
  -- Launch a terminal
  [ ((modm, xK_Return), spawn $ XMonad.terminal conf)
  -- Launch dmenu
  , ((modm, xK_e), spawn "dmenu_run")
  -- Close focused window
  , ((modm .|. shiftMask, xK_semicolon), kill)
  -- Rotate through the available layout algorithms
  , ((modm, xK_space), sendMessage NextLayout)
  -- Reset the layouts on the current workspace to default
  , ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
  -- Resize viewed windows to the correct size
  -- , ((modm, xK_b), refresh)
  -- Window ...
  -- ... select
  , ((modm, xK_h), sendMessage $ Go L)
  , ((modm, xK_t), sendMessage $ Go D)
  , ((modm, xK_n), sendMessage $ Go U)
  , ((modm, xK_s), sendMessage $ Go R)
  -- ... swap
  , ((modm .|. shiftMask, xK_h), sendMessage $ Swap L)
  , ((modm .|. shiftMask, xK_t), sendMessage $ Swap D)
  , ((modm .|. shiftMask, xK_n), sendMessage $ Swap U)
  , ((modm .|. shiftMask, xK_s), sendMessage $ Swap R)
  -- ... move
  , ((modm .|. controlMask .|. shiftMask, xK_h), sendMessage $ Move L)
  , ((modm .|. controlMask .|. shiftMask, xK_t), sendMessage $ Move D)
  , ((modm .|. controlMask .|. shiftMask, xK_n), sendMessage $ Move U)
  , ((modm .|. controlMask .|. shiftMask, xK_s), sendMessage $ Move R)
  -- Move focus to the ...
  -- ... next window
  , ((modm, xK_Tab), windows W.focusDown)
  , ((modm, xK_c), windows W.focusDown)
  -- ... previous window
  , ((modm .|. shiftMask, xK_Tab), windows W.focusUp)
  , ((modm, xK_r), windows W.focusUp)
  -- ... master window
  , ((modm, xK_m), windows W.focusMaster)
  -- Swap the focused window with the ...
  -- ... next window
  , ((modm .|. shiftMask, xK_c), windows W.swapDown)
  -- ... previous window
  , ((modm .|. shiftMask, xK_r), windows W.swapUp)
  -- ... master window
  , ((modm .|. shiftMask, xK_m), windows W.swapMaster)
  -- Change the master area
  , ((modm, xK_w), sendMessage Shrink)
  , ((modm, xK_v), sendMessage Expand)
  -- Push window back into tiling
  , ((modm, xK_y), withFocused $ windows . W.sink)
  -- Change the number of windows in the master area
  , ((modm .|. shiftMask, xK_w), sendMessage (IncMasterN 1))
  , ((modm .|. shiftMask, xK_v), sendMessage (IncMasterN (-1)))
  -- Multimedia keys
  , ((0, xF86XK_AudioRaiseVolume), spawn "amixer sset Master 1%+")
  , ((0, xF86XK_AudioLowerVolume), spawn "amixer sset Master 1%-")
  , ((0, xF86XK_AudioMute), spawn "amixer-toggle")
  , ((0, xF86XK_Launch1), spawn "autorandr-switch")
  , ((modm, xK_Right), spawn "amixer sset Master 1%+")
  , ((modm, xK_Left), spawn "amixer sset Master 1%-")
  -- Brightness keys
  , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -inc 1")
  , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -dec 1")
  , ((modm, xK_Up), spawn "xbacklight -inc 1")
  , ((modm, xK_Down), spawn "xbacklight -dec 1")
  , ((modm .|. shiftMask, xK_Up), spawn "xbacklight -inc 5")
  , ((modm .|. shiftMask, xK_Down), spawn "xbacklight -dec 5")
  -- Quit xmonad and restart xmonad
  , ((modm .|. shiftMask, xK_q), io (exitWith ExitSuccess))
  , ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart")
  -- Run xmessage with a summary of the default keybindings (useful for
  -- beginners)
  , ( (modm .|. shiftMask, xK_slash)
    , spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
  ] ++
  -- mod-myNumRow, Switch to workspace N
  -- mod-shift-myNumRow, Move client to workspace N
  [ ((m .|. modm, k), windows $ f i)
  | (i, k) <- zip (XMonad.workspaces conf) myNumRow
  , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ] ++
  -- mod-{,,.,p}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{,,.,p}, Move client to screen 1, 2, or 3
  [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
  | (key, sc) <- zip [xK_comma, xK_period, xK_p] [0 ..]
  , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
  ] ++
  -- Utilities
  [ ((modm .|. controlMask, xK_BackSpace), spawn "xscreensaver-command -lock")
  , ( (modm .|. controlMask, xK_Print)
    , spawn
        "sleep 0.2; scrot -s \"$HOME/Pictures/screenshots/%Y-%m-%d:%H:%M:%S.png\"")
  , ( (modm, xK_Print)
    , spawn "scrot \"$HOME/Pictures/screenshots/%Y-%m-%d:%H:%M:%S.png\"")
  ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList $
  -- mod-button1, Set the window to floating mode and move by dragging
  [ ( (modm, button1)
    , (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))
  -- mod-button2, Raise the window to the top of the stack
  , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
  -- mod-button3, Set the window to floating mode and resize by dragging
  , ( (modm, button3)
    , (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
  -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

------------------------------------------------------------------------
-- Layouts:
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
myLayout =
  avoidStruts $ windowNavigation $ tiled ||| Mirror tiled ||| noBorders Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2
    -- Percent of screen to increment by when resizing panes
    delta = 3 / 100

------------------------------------------------------------------------
-- Window rules:
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
myManageHook =
  manageDocks <+>
  composeAll
    [ className =? "MPlayer" --> doFloat
    , className =? "Gimp" --> doFloat
    , resource =? "desktop_window" --> doIgnore
    ]

------------------------------------------------------------------------
-- Event handling
-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
myEventHook = ewmhDesktopsEventHook

------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
myLogHook hs = do
  mapM_ (\h -> dynamicLogWithPP xmobarPP {ppOutput = hPutStrLn h}) hs

------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
-- Run xmonad with the settings you specify. No need to modify this.
main = do
  n <- countScreens
  hs <-
    mapM
      (\i -> spawnPipe $ "xmobar -x " ++ show i ++ " /home/koo/.xmonad/xmobarrc")
      [0 .. n - 1]
  xmonad $ docks $ defaults hs

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
defaults hs =
  def
    -- simple stuff
    { terminal = myTerminal
    , focusFollowsMouse = myFocusFollowsMouse
    , clickJustFocuses = myClickJustFocuses
    , borderWidth = myBorderWidth
    , modMask = myModMask
    , workspaces = myWorkspaces
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    -- key bindings
    , keys = myKeys
    , mouseBindings = myMouseBindings
    -- hooks, layouts
    , layoutHook = myLayout
    , manageHook = myManageHook
    , handleEventHook = myEventHook
    , logHook = myLogHook hs
    , startupHook = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help =
  unlines
    [ "The default modifier key is 'alt'. Default keybindings:"
    , ""
    , "-- launching and killing programs"
    , "mod-Shift-Enter  Launch xterminal"
    , "mod-p            Launch dmenu"
    , "mod-Shift-p      Launch gmrun"
    , "mod-Shift-c      Close/kill the focused window"
    , "mod-Space        Rotate through the available layout algorithms"
    , "mod-Shift-Space  Reset the layouts on the current workSpace to default"
    , "mod-n            Resize/refresh viewed windows to the correct size"
    , ""
    , "-- move focus up or down the window stack"
    , "mod-Tab        Move focus to the next window"
    , "mod-Shift-Tab  Move focus to the previous window"
    , "mod-j          Move focus to the next window"
    , "mod-k          Move focus to the previous window"
    , "mod-m          Move focus to the master window"
    , ""
    , "-- modifying the window order"
    , "mod-Return   Swap the focused window and the master window"
    , "mod-Shift-j  Swap the focused window with the next window"
    , "mod-Shift-k  Swap the focused window with the previous window"
    , ""
    , "-- resizing the master/slave ratio"
    , "mod-h  Shrink the master area"
    , "mod-l  Expand the master area"
    , ""
    , "-- floating layer support"
    , "mod-t  Push window back into tiling; unfloat and re-tile it"
    , ""
    , "-- increase or decrease number of windows in the master area"
    , "mod-comma  (mod-,)   Increment the number of windows in the master area"
    , "mod-period (mod-.)   Deincrement the number of windows in the master area"
    , ""
    , "-- quit, or restart"
    , "mod-Shift-q  Quit xmonad"
    , "mod-q        Restart xmonad"
    , "mod-[1..9]   Switch to workSpace N"
    , ""
    , "-- Workspaces & screens"
    , "mod-Shift-[1..9]   Move client to workspace N"
    , "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3"
    , "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3"
    , ""
    , "-- Mouse bindings: default actions bound to mouse events"
    , "mod-button1  Set the window to floating mode and move by dragging"
    , "mod-button2  Raise the window to the top of the stack"
    , "mod-button3  Set the window to floating mode and resize by dragging"
    ]
