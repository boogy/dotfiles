--
-- Boogy Xmonad
--

-- System
import System.IO
import System.Exit

-- XMonad
import XMonad hiding ( (|||) ) -- jump to layout
import XMonad.Layout.LayoutCombinators (JumpToLayout(..), (|||)) -- jump to layout
import XMonad.ManageHook

-- Hooks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, docksStartupHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat, doRectFloat)
import XMonad.Hooks.Minimize
import XMonad.Hooks.UrgencyHook

-- Config
import XMonad.Config.Desktop
import XMonad.Config.Azerty
import qualified Codec.Binary.UTF8.String as UTF8

-- Util
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings, additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare (getSortByTag, getSortByIndex, getSortByXineramaPhysicalRule, getSortByXineramaRule)
import XMonad.Util.NamedWindows
import XMonad.Util.Loggers

-- Layouts
-- import XMonad.Layout.Grid
import XMonad.Layout.GridVariants
import XMonad.Layout.NoBorders
import XMonad.Layout.ToggleLayouts          -- Full window at any time
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Mosaic
import XMonad.Layout.CenteredMaster (centerMaster)
import XMonad.Layout.Renamed (renamed, Rename(Replace, CutWordsLeft))
import XMonad.Layout.Tabbed
-- import XMonad.Layout.Fullscreen
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Minimize
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.ResizableTile
-- import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Cross(simpleCross)
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle as MToggle
import XMonad.Layout.MultiToggle.Instances
-- import XMonad.Layout.IndependentScreens


-- actions
import XMonad.Actions.CopyWindow    -- for dwm window style tagging
import XMonad.Actions.UpdatePointer -- update mouse postion
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS
import XMonad.Actions.Submap
import XMonad.Actions.GridSelect
import XMonad.Actions.WindowBringer
import XMonad.Actions.Commands

-- Graphics and Data
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import Control.Monad (liftM2)
import Data.Ratio ((%)) -- for video

-- DBUS (for polybar)
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8


-- colours
normBord = "#4c566a"
focdBord = "#5e81ac"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

-- fg        = "#ebdbb2"
-- bg        = "#282828"
-- gray      = "#a89984"
-- bg1       = "#3c3836"
-- bg2       = "#505050"
-- bg3       = "#665c54"
-- bg4       = "#7c6f64"

green      = "#b8bb26"
darkgreen  = "#98971a"
red        = "#fb4934"
darkred    = "#cc241d"
yellow     = "#fabd2f"
yellow2    = "#ffb52a"
yellow3    = "#ffb52a"
blue       = "#83a598"
purple     = "#d3869b"
aqua       = "#8ec07c"
white      = "#eeeeee"
pur2       = "#5b51c9"
blue2      = "#2266d0"
background = "#2f343f"


-- mod4Mask= super key
-- mod1Mask= alt key
-- controlMask= ctrl key
-- shiftMask= shift key
myModMask = mod1Mask
encodeCChar = map fromIntegral . B.unpack
myFocusFollowsMouse = True
myBorderWidth = 2

myBrowser = "firefox"
myTerminal = "alacritty"
myNormalBorderColor = "#4c566a"
myFocusedBorderColor = "#3bff3b"

myAlt = myModMask
mySup = mod4Mask


--
-- Workspaces
--
myWS1 = "\61728"
myWS2 = "\57351"
myWS3 = "\61632"
myWS4 = "\63092"
myWS5 = "\61704"
myWS6 = "\62835"
myWS7 = "\61564"
myWS8 = "\61450"
myWS9 = "\61477"
myWS0 = "\62440"

-- myWorkspaces ["", "", "", "", "", "", "", "", "", ""]
myWorkspaces =  [myWS1,myWS2,myWS3,myWS4,myWS5,myWS6,myWS7,myWS8,myWS9,myWS0]

-- myBaseConfig = desktopConfig
myBaseConfig = desktopConfig


-- window manipulations
-- actions: doFloat, doCenterFloat, doIgnore
myManageHook = composeAll . concat $
    [ [ isDialog            --> doCenterFloat                    ]
    , [ className =? c      --> doCenterFloat  | c <- myCFloats  ]
    , [ title     =? t      --> doCenterFloat  | t <- myTFloats  ]
    , [ resource  =? r      --> doFloat        | r <- myRFloats  ]
    , [ resource  =? i      --> doIgnore       | i <- myIgnores  ]

    , [ className =? "zoom"    <&&> title    =? "Zoom - Licensed Account" --> doCenterFloat ]
    , [ className =? "firefox" <&&> title    =? "Library"                 --> doCenterFloat ]
    , [ className =? "Firefox" <&&> resource =? "Toolkit"                 --> doFloat       ]

    , [ isFullscreen        --> doFullFloat     ]
    , [ namedScratchpadManageHook myScratchpads ]

    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo myWS1 | x <- my1Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo myWS2 | x <- my2Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo myWS3 | x <- my3Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo myWS4 | x <- my4Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo myWS5 | x <- my5Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo myWS6 | x <- my6Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo myWS7 | x <- my7Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo myWS8 | x <- my8Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo myWS9 | x <- my9Shifts]
    , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo myWS0 | x <- my10Shifts]
    ]
    where
        doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
        myCFloats = [   "Arandr",
                        "Pavucontrol", "Places", "Galculator", "feh", "mpv",
                        "Xfce4-terminal", "Shutter", "Blueman-manager", "vlc",
                        "Nm-connection-editor", "Gnome-calculator", "Eog", "Piper"
                    ]
        myTFloats = ["Downloads", "Save As..."]
        myRFloats = []
        myIgnores = ["desktop_window"]
        my1Shifts = ["Chromium"]
        my2Shifts = []
        my3Shifts = []
        my4Shifts = []
        my5Shifts = ["VirtualBox Manager", "Virtualbox", "Vmware"]
        my6Shifts = ["sofice", "Sofice", "libreoffice", "Libreoffice", "libreoffice-writer", "libreoffice-calc"]
        my7Shifts = ["Virtualbox"]
        my8Shifts = ["Thunar"]
        my9Shifts = ["zoom"]
        my10Shifts = []


------------------------------------------------------------------------
-- scratchpads
------------------------------------------------------------------------

myScratchpads = [ NS "terminal" "alacritty --class=scratchpad -t scratchpad -e tmux new-session -A -s SCRATCHPAD" (title =? "scratchpad") (customFloating (W.RationalRect 0.1 0.1 0.8 0.8))
                , NS "notes" spawnTerm findTerm manageTerm
                , NS "thunar-scratchpad" "thunar --name=thunar-scratchpad --class=thunar-scratchpad" (className=? "thunar-scratchpad") (customFloating (W.RationalRect 0.1 0.1 0.8 0.8))
                ]
    where
        role = stringProperty "WM_WINDOW_ROLE"
        spawnTerm = myTerminal ++  " --class NOTES"
        findTerm = resource =? "scratchpad"
        manageTerm = nonFloating


------------------------------------------------------------------------
-- Tabbed config
------------------------------------------------------------------------
myTabConfig = def { activeColor = "#556064"
                  , inactiveColor = "#2F3D44"
                  , urgentColor = "#FDF6E3"
                  , activeBorderColor = "#454948"
                  , inactiveBorderColor = "#454948"
                  , urgentBorderColor = "#268BD2"
                  , activeTextColor = "#80FFF9"
                  , inactiveTextColor = "#1ABC9C"
                  , urgentTextColor = red
                  , fontName = "xft:Noto Sans:size=12:antialias=true"
                  }

--
-- Per workspace layouts
--
perWS = onWorkspace myWS1 myFullFirst  $
        onWorkspace myWS2 myFullFirst  $
        onWorkspace myWS3 myTiledFirst $
        onWorkspace myWS4 myTiledFirst $
        onWorkspace myWS5 myFullFirst  $
        onWorkspace myWS8 myTiledFirst $
        onWorkspace myWS9 myFullFirst  $
        onWorkspace myWS0 myFullFirst  $
        myAll -- all layouts for all other workspaces

--
-- define layout combinations
--
myFullFirst  = myFull  ||| myTiled ||| myTabs ||| myThreeCol
myTiledFirst = myTiled ||| myFull  ||| myTabs ||| myThreeCol
myTiledFull  = myTiled ||| myFull
myFullTabs   = myFull  ||| myTabs
myAll        = myTiled ||| myFull  ||| myTabs ||| myThreeCol

--
-- Layout variables
--
myFull = renamed [Replace "Full"]
        $ noBorders (Full)

myTiled = renamed [Replace "Tall"]
        $ mkToggle (NOBORDERS ?? FULL ?? EOT)
        $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True
        $ ResizableTall 1 (3/100) (1/2) []

myTabs = renamed [Replace "Tabbed"]
        $ mkToggle (NOBORDERS ?? FULL ?? EOT)
        $ noBorders (tabbed shrinkText myTabConfig)

myThreeCol = renamed [Replace "ThreeColMid"]
            $ mkToggle (NOBORDERS ?? FULL ?? EOT)
            $ ThreeColMid 1 (3/100) (1/2)

-- myLayout = renamed [CutWordsLeft 1] . avoidStruts . minimize $ perWS
myLayout = avoidStruts $ perWS


-- myLayout = avoidStruts (full ||| tiled ||| tabs ||| threeCol)
--   where
--     full = renamed [Replace "Full"]
--         $ noBorders (Full)
--     tiled = renamed [Replace "Tall"]
--         $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True
--         $ ResizableTall 1 (3/100) (1/2) []
--     tabs = renamed [Replace "Tabbed"]
--         $ noBorders (tabbed shrinkText myTabConfig)
--     threeCol = renamed [Replace "ThreeColMid"]
--         $ ThreeColMid 1 (3/100) (1/2)
--     -- grid = renamed [Replace "Grid"]
--     --     $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True
--     --     $ Grid (16/10)
--     -- bsp = renamed [Replace "BSP"]
--     --     $ emptyBSP
--     -- The default number of windows in the master pane
--     nmaster = 1
--     -- Default proportion of screen occupied by master pane
--     ratio   = 1/2
--     -- Percent of screen to increment by when resizing panes
--     delta   = 3/100


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))

    -- mod-button 4 & 5
    -- , ((modMask, button4), (\_ -> windows W.focusUp  ))
    -- , ((modMask, button5), (\_ -> windows W.focusDown))
    -- , ((modMask, button4), (\w -> spawn "xdotool key Alt+n"))
    ]


commands :: X [(String, X ())]
commands = defaultCommands

-- keys config

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    [ ((modMask, xK_Return),                 spawn $ myTerminal )
    , ((modMask .|. shiftMask, xK_Return),   spawn $ "alacritty --class=work -t work -e tmux new-session -A -s WORK")
    , ((modMask, xK_Escape),                 spawn $ "xkill" )
    , ((modMask .|. shiftMask , xK_c),       kill)

    -- Application menus
    , ((modMask, xK_F11),                    spawn $ "rofi -show run -fullscreen" )
    , ((mySup, xK_d    ),                    spawn $ "rofi -show drun -lines 10 -columns 1 -width 45 -sidebar-mode" )
    , ((modMask, xK_e  ),                    spawn $ "dmenu_run" )
    , ((modMask, xK_y  ),                    spawn $ "polybar-msg cmd toggle" )

    , ((mySup, xK_e    ),                    spawn $ "thunar")

    -- XMonad recompile / restart
    , ((modMask .|. shiftMask , xK_r ),      spawn $ "xmonad --recompile && xmonad --restart")
    , ((modMask, xK_r                ),      spawn $ "xmonad --restart")

    -- , ((modMask .|. shiftMask , xK_x ), io (exitWith ExitSuccess))

    , ((controlMask .|. mod1Mask , xK_g )      , spawn $ "chromium -no-default-browser-check")
    , ((controlMask .|. mod1Mask , xK_u )      , spawn $ "pavucontrol")
    , ((controlMask .|. shiftMask , xK_Escape ), spawn $ "xfce4-taskmanager")

    -- SCREENSHOTS

    , ((0, xK_Print),                 spawn $ "flameshot gui")
    , ((0 .|. shiftMask , xK_Print ), spawn $ "shutter -s")

    -- MULTIMEDIA KEYS

    -- Mute volume
    , ((0, xF86XK_AudioMute),         spawn $ "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((0, xF86XK_AudioMicMute),      spawn $ "amixer set Capture toggle")
    , ((0, xK_F12),                   spawn $ "amixer set Capture toggle" )
    , ((0, xF86XK_AudioLowerVolume),  spawn $ "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ((0, xF86XK_AudioRaiseVolume),  spawn $ "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0, xF86XK_MonBrightnessUp),   spawn $ "xbacklight -inc 5")
    , ((0, xF86XK_MonBrightnessDown), spawn $ "xbacklight -dec 5")

    -- Submap key bindings
    , ((modMask, xK_o), submap . M.fromList $
        [ ((0, xK_p),     spawn "pavucontrol")
        , ((0, xK_f),     spawn "firefox")
        , ((0, xK_a),     spawn myTerminal)
        , ((0, xK_g),     spawn "gvim")
        , ((0, xK_v),     spawn "VBoxManage startvm 'Windows10' --type gui")
        ])

    , ((mySup, xK_l), submap . M.fromList $
        [ ((0, xK_f),     sendMessage $ JumpToLayout "Full"  )
        , ((0, xK_t),     sendMessage $ JumpToLayout "Tabbed")
        , ((0, xK_l),     sendMessage $ JumpToLayout "Tall"  )
        ])

    -- scratchpads
    , ((mySup  , xK_u), namedScratchpadAction myScratchpads "thunar-scratchpad")
    , ((modMask, xK_u), namedScratchpadAction myScratchpads "terminal")


    --------------------------------------------------------------------
    --  XMONAD LAYOUT KEYS

    -- Cycle through the available layout algorithms.
    , ((mySup, xK_space), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modMask.|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Move focus to the next window
    , ((mySup, xK_Tab), windows W.focusDown)

    -- CycleWS setup
    -- cycle workspaces back and forth
    , ((myAlt, xK_Tab),              toggleWS)        -- toggle workspaces focus
    , ((myAlt, xK_n),                nextWS)          -- next workspace
    , ((myAlt, xK_p),                prevWS)          -- previous workspace
    , ((myAlt .|. shiftMask, xK_n),  shiftToNext)     -- shift to next workspace
    , ((myAlt .|. shiftMask, xK_p),  shiftToPrev)     -- shift to prev workspace
    , ((mySup .|. shiftMask, xK_n),  shiftNextScreen) -- shift to next screen
    , ((mySup .|. shiftMask, xK_p),  shiftPrevScreen) -- shift to previous screen

    -- , ((mySup .|. shiftMask, xK_n),  shiftNextScreen >> nextScreen) -- shift to next screen
    -- , ((mySup .|. shiftMask, xK_p),  shiftPrevScreen >> prevScreen) -- shift to previous screen

    -- Move focus to the next window.
    , ((modMask, xK_j), windows W.focusDown)

    -- Move focus to the previous window.
    , ((modMask, xK_k), windows W.focusUp  )

    -- Move focus to the master window.
    , ((modMask .|. shiftMask, xK_m), windows W.focusMaster  )

    -- Swap the focused window with the next window.
    , ((modMask .|. shiftMask, xK_j), windows W.swapDown  )

    -- Swap the focused window with the next window.
    , ((controlMask .|. modMask, xK_Down), windows W.swapDown  )

    -- Swap the focused window with the previous window.
    , ((modMask .|. shiftMask, xK_k), windows W.swapUp    )

    -- Swap the focused window with the previous window.
    , ((controlMask .|. modMask, xK_Up), windows W.swapUp  )

    -- Shrink the master area.
    , ((controlMask .|. shiftMask , xK_h), sendMessage Shrink)

    -- Expand the master area.
    , ((controlMask .|. shiftMask , xK_l), sendMessage Expand)

    -- Push window back into tiling.
    , ((modMask, xK_space), toggleFloat)
    -- , ((modMask, xK_space),     withFocused toggleFloat)
    -- , ((mySup,   xK_space),     withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area.
    , ((controlMask .|. modMask, xK_Left), sendMessage (IncMasterN 1))

    -- Decrement the number of windows in the master area.
    , ((controlMask .|. modMask, xK_Right), sendMessage (IncMasterN (-1)))

    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- XMonad.Layout.MultiToggle
    , ((modMask, xK_f), sendMessage $ MToggle.Toggle FULL)

    , ((modMask, xK_g),                    spawn "rofi -show window") -- focus windows
    , ((modMask .|. shiftMask, xK_b     ), bringMenu                ) -- bring windows to the current workspace
    -- , ((modMask .|. shiftMask, xK_g     ), gotoMenu)

    , ((modMask .|. controlMask, xK_y), commands >>= runCommand)

    -- toggle strucs for windows
    , ((mySup, xK_s), sendMessage ToggleStruts)

    ]
    ++
    -- mod-[1..9],       Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modMask, k), windows $ f i)

    --Keyboard layouts
    --qwerty users use this line
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]

    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
    , (\i -> W.greedyView i . W.shift i, shiftMask)]
    ]
    ++
    -- ctrl-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- ctrl-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. mod1Mask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_period, xK_comma] [0..]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


-- Additional keys
-- M4 == Sup
-- M  == Alt
myAdditionalKeys=
    -- [("M-" ++ m ++ k, windows $ f i)
    --     | (i, k) <- zip (myWorkspaces) (map show [1 :: Int ..])
    --     , (f, m) <- [(W.greedyView, ""), (W.shift, "S-"), (copy, "S-C-")]]
    -- ++
    [ ("S-C-a", windows copyToAll)   -- copy window to all workspaces
    , ("S-C-z", killAllOtherCopies)  -- kill copies of window on other workspaces
    , ("M4-a",  sendMessage MirrorExpand)
    , ("M4-z",  sendMessage MirrorShrink)

    -- move focus to next Screen and update mouse pointer position
    , ("M-e"  , nextScreen >> updatePointer (0.5, 0.5) (0, 0))
    ]

------------------------------------------------------------------------
-- custom desktop notifications -- dunst package required
-- run an action on notifications
------------------------------------------------------------------------
-- data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)
-- instance UrgencyHook LibNotifyUrgencyHook where
--     urgencyHook LibNotifyUrgencyHook w = do
--         name     <- getName w
--         Just idx <- fmap (W.findTag w) $ gets windowset
--         safeSpawn "notify-send" [show name, "workspace " ++ idx]


-- execute when xmonad starts
myStartupHook = do
    spawn "$HOME/.xmonad/autostart.sh"
    setWMName "LG3D"
    -- spawnOn myWS1 "alacritty --class=work -t work -e tmux new-session -A -s WORK"
    -- spawnOn myWS2 myBrowser


--
-- MAIN FUNCTION
--
main :: IO ()
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    xmonad
        $ withUrgencyHook NoUrgencyHook
        $ ewmh
        $ myBaseConfig {
            startupHook          = myStartupHook
            , layoutHook         = myLayout
            , manageHook         = manageDocks
                                    <+> (isFullscreen --> doFullFloat)
                                    <+> manageSpawn
                                    <+> myManageHook
                                    <+> manageHook myBaseConfig
            , modMask            = myModMask
            , borderWidth        = myBorderWidth
            , handleEventHook    = fullscreenEventHook
                                    <+> ewmhDesktopsEventHook
                                    <+> handleEventHook myBaseConfig
            , focusFollowsMouse  = myFocusFollowsMouse
            , workspaces         = myWorkspaces
            , focusedBorderColor = myFocusedBorderColor
            , normalBorderColor  = myNormalBorderColor
            , keys               = myKeys
            , logHook            = dynamicLogWithPP (myLogHook dbus)
            , mouseBindings      = myMouseBindings
        } `additionalKeysP` myAdditionalKeys



-----------------------------------------------------------------------------
-- LOGHOOK
-----------------------------------------------------------------------------
-- %{F} == foreground
-- %{B} == background
myLogHook :: D.Client -> PP
myLogHook dbus = def
    { ppOutput           = dbusOutput dbus
    , ppCurrent          = wrap ("%{B" ++ yellow3 ++ "} ") " %{B-}"
    , ppVisible          = wrap ("%{B" ++ yellow  ++ "} ") " %{B-}"
    , ppUrgent           = wrap ("%{B" ++ red     ++ "} ") " %{B-}"
    , ppHidden           = wrap " " " "
    , ppWsSep            = " "
    , ppSep              = " | "
    -- remove this to hide empty workspaces
    , ppSort             = fmap (. namedScratchpadFilterOutWorkspace) getSortByIndex
    , ppHiddenNoWindows  = wrap " " " "
    , ppLayout           = wrap "\63564 " ""
    , ppTitle            = myAddSpaces 30

    -- , ppExtras          = [logCmd "echo ASD", windowCount]
    -- add polybar actions from xmonad
    , ppExtras           = [wrapL "%{A1:rofi -show window &:}\62162 %{A}" " " windowCount]
    , ppOrder            = \(ws:l:t:ex) -> [ws,l]++ex++[t]
    }


-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"


myAddSpaces :: Int -> String -> String
myAddSpaces len str = sstr ++ replicate (len - length sstr) ' '
  where
    sstr = shorten len str


-- #################
-- ### FUNCTIONS ###
-- #################


--
-- Toggle floating window in the center
--
centreRect = W.RationalRect 0.25 0.25 0.5 0.5
-- If the window is floating then (f), if tiled then (n)
floatOrNot f n = withFocused $ \windowId -> do
    floats <- gets (W.floating . windowset)
    if windowId `M.member` floats -- if the current window is floating...
       then f
       else n
-- Centre and float a window (retain size)
centreFloat win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
    return ()
-- Float a window in the centre
myCentreFloat w = windows $ W.float w centreRect
-- Make a window my 'standard size' (half of the screen) keeping the centre of the window fixed
standardSize win = do
    (_, W.RationalRect x y w h) <- floatLocation win
    windows $ W.float win (W.RationalRect x y 0.5 0.5)
    return ()
-- Float and centre a tiled window, sink a floating window
toggleFloat = floatOrNot (withFocused $ windows . W.sink) (withFocused myCentreFloat)


-- toogle float window simple
-- toggleFloat w = windows (\s -> if M.member w (W.floating s)
--             then W.sink w s
--             else (W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s))

-- myCenterWindow :: Window -> X ()
-- myCenterWindow win = do
--     (_, W.RationalRect x y w h) <- floatLocation win
--     windows $ W.float win (W.RationalRect ((1 - w) / 2) ((1 - h) / 2) w h)
--     return ()

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

--
-- Example of multiple xmobar bars per screen
--
-- import XMonad
-- import XMonad.Util.Run
-- import XMonad.Layout.IndependentScreens
-- main = do
--     n <- countScreens
--     xmprocs <- mapM (\i -> spawnPipe $ "xmobar /home/biskulopty/.xmobarrc-" ++ show i ++ " -x " ++ show i) [0..n-1]
--     xmonad def {
--         logHook = [> use xmprocs, which is a list of pipes of type [Handle] <]
--     }


-- For multiple monitors I use XMonad.Hooks.DynamicBars. The way this package handles multiple monitors is to spawn a separate bar for each window with something like
-- spawnPipe $ "xmobar -x " ++ show sid
-- for each screen id (0,1..).The -x tells xmobar which screen to display the bar on.
