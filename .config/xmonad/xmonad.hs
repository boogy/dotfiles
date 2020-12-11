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
import XMonad.Hooks.ManageDocks (avoidStruts, docksStartupHook, manageDocks, ToggleStruts(..), docksEventHook)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat, doRectFloat)
import XMonad.Hooks.Minimize
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ServerMode
import XMonad.Hooks.WorkspaceHistory (workspaceHistoryHook)

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
-- import XMonad.Layout.Fullscreen (fullscreenFull)
-- import XMonad.Layout.IndependentScreens
-- import XMonad.Layout.Grid
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.NoBorders
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.BinarySpacePartition as BSP (Swap, emptyBSP)
import XMonad.Layout.Mosaic
import XMonad.Layout.CenteredMaster (centerMaster)
import XMonad.Layout.Renamed (renamed, Rename(Replace, CutWordsLeft))
import XMonad.Layout.Tabbed (tabbed, addTabs, shrinkText, Theme(..))
-- import XMonad.Layout.SimpleDecoration (shrinkText)
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Minimize
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.ResizableTile
import XMonad.Layout.Cross(simpleCross)
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??), Toggle)
import XMonad.Layout.MultiToggle.Instances (StdTransformers(FULL, NBFULL, MIRROR, NOBORDERS, SMARTBORDERS))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.SubLayouts
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Magnifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)


-- actions
import XMonad.Actions.CopyWindow    -- for dwm window style tagging
import XMonad.Actions.UpdatePointer -- update mouse postion
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS ( toggleWS, moveTo, shiftTo, shiftToNext, shiftToPrev, prevWS, nextWS,
                                nextScreen, prevScreen, shiftNextScreen, shiftPrevScreen,
                                Direction1D(..), WSType(..)
                              )
import XMonad.Actions.Navigation2D
import XMonad.Actions.Submap
import XMonad.Actions.GridSelect
import XMonad.Actions.WindowBringer
import XMonad.Actions.Commands
import XMonad.Actions.MouseResize

-- Graphics and Data
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import Control.Monad (liftM2)
import Data.Ratio ((%)) -- for video
import qualified Data.Text as T
import Data.Maybe (isJust)

-- DBUS (for polybar)
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8


-- -------------------------------------------------------------------------------------------------------
-- Variables
-- -------------------------------------------------------------------------------------------------------
normBord = "#4c566a"
focdBord = "#5e81ac"
fore     = "#DEE3E0"
black     = "#282c34"
winType  = "#c678dd"
-- fg        = "#ebdbb2"
-- bg        = "#282828"
-- gray      = "#a89984"
-- bg1       = "#3c3836"
-- bg2       = "#505050"
-- bg3       = "#665c54"
-- bg4       = "#7c6f64"
green      = "#3bff3b"
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
myBorderWidth = 3

myBrowser = "firefox"
myTerminal = "alacritty"
-- myNormalBorderColor = "#4c566a"
-- myFocusedBorderColor = "#3bff3b"
myNormalBorderColor = "#4c566a"
myFocusedBorderColor = yellow3

myAlt = myModMask
mySup = mod4Mask

myFont = "xft:Mononoki Nerd Font:bold:size=9:antialias=true:hinting=true"


-- -------------------------------------------------------------------------------------------------------
-- Workspaces
-- -------------------------------------------------------------------------------------------------------
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


-- -------------------------------------------------------------------------------------------------------
-- Window rules and manipulation (doFloat) (doCenterFloat) (doIgnore)
-- -------------------------------------------------------------------------------------------------------
myRectFloatRational = do
    doRectFloat (W.RationalRect (0 % 4) (1 % 4) (1 % 2) (1 % 2))

myManageHook = composeAll . concat $
    [ [ isDialog            --> doCenterFloat                    ]
    , [ className =? c      --> doCenterFloat  | c <- myCFloats  ]
    , [ title     =? t      --> doCenterFloat  | t <- myTFloats  ]
    , [ resource  =? r      --> doFloat        | r <- myRFloats  ]
    , [ resource  =? i      --> doIgnore       | i <- myIgnores  ]

    , [ className =? "firefox" <&&> title    =? "Library"                 --> doCenterFloat ]
    , [ className =? "Firefox" <&&> resource =? "Toolkit"                 --> doFloat       ]
    , [ className =? "zoom"    <&&> title    =? "Zoom - Licensed Account" --> myRectFloatRational >> doCenterFloat]
    , [ className =? "zoom"    <&&> title    =? "Settings"                --> myRectFloatRational >> doCenterFloat]

    -- , [ className =? "Polybar"  --> (doF W.focusDown <+> doIgnore)]

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
    -- Allows focusing other monitors without killing the fullscreen
    --  [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
    ]
    where
        doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
        myCFloats = [   "Arandr"               , "Places"             , "Nitrogen"          , "feh"    , "mpv" ,
                        "Xfce4-terminal"       , "Shutter"            , "Blueman-manager"   , "vlc"    ,
                        "Nm-connection-editor" , "Gnome-calculator"   , "Eog"               , "Piper"  ,
                        "Evince"               , "VirtualBox Manager" , "Xfce4-taskmanager" , "Xfrun4" ,
                        "Xfce4-appfinder"      , "Pavucontrol"
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
        my7Shifts = ["Thunar"]
        my8Shifts = []
        my9Shifts = ["zoom"]
        my10Shifts = []


-- -------------------------------------------------------------------------------------------------------
-- Scratchpads
-- -------------------------------------------------------------------------------------------------------
myScratchpads = [ NS "terminal" "alacritty --class=scratchpad -t scratchpad -e tmux new-session -A -s SCRATCHPAD" (title =? "scratchpad") (customFloating (W.RationalRect 0.1 0.1 0.8 0.8))
                , NS "notes" spawnTerm findTerm manageTerm
                -- , NS "thunar-scratchpad" "thunar --name=thunar-scratchpad --class=thunar-scratchpad" (className=? "thunar-scratchpad") (customFloating (W.RationalRect 0.1 0.1 0.8 0.8))
                ]
    where
        role = stringProperty "WM_WINDOW_ROLE"
        spawnTerm = myTerminal ++  " --class NOTES"
        findTerm = resource =? "scratchpad"
        manageTerm = nonFloating


-- -------------------------------------------------------------------------------------------------------
-- Tabbed config
-- -------------------------------------------------------------------------------------------------------
myTabConfig = def { activeColor = "#556064"
                  , inactiveColor = "#2F3D44"
                  , urgentColor = "#FDF6E3"
                  , activeBorderColor = "#454948"
                  , inactiveBorderColor = "#454948"
                  , urgentBorderColor = "#268BD2"
                  , activeTextColor = "#80FFF9"
                  , inactiveTextColor = "#1ABC9C"
                  , urgentTextColor = "#1ABC9C"
                  , fontName = "xft:Noto Sans CJK:size=10:antialias=true"
                  }

-- -------------------------------------------------------------------------------------------------------
-- Per workspace layouts
-- -------------------------------------------------------------------------------------------------------
perWS = onWorkspace myWS1 myFullFirst  $
        onWorkspace myWS2 myFullFirst  $
        onWorkspace myWS3 myTiledFirst $
        onWorkspace myWS4 myFullFirst  $
        onWorkspace myWS5 myFullFirst  $
        onWorkspace myWS6 myFullFirst  $
        onWorkspace myWS8 myTiledFirst $
        onWorkspace myWS9 myFullFirst  $
        onWorkspace myWS0 myFullFirst  $
        myAll -- all layouts for all other workspaces

-- -------------------------------------------------------------------------------------------------------
-- Layout combinations
-- -------------------------------------------------------------------------------------------------------
myTiledFirst = myTiled ||| myFull  ||| myTabs ||| myThreeCol ||| myGrid ||| myBsp
myFullFirst  = myFull  ||| myTiled ||| myTabs ||| myThreeCol ||| myGrid ||| myBsp
myAll        = myTiled ||| myFull  ||| myTabs ||| myThreeCol ||| myGrid ||| myBsp

-- -------------------------------------------------------------------------------------------------------
-- Layout variables
-- -------------------------------------------------------------------------------------------------------
mySpacingRaw  = spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True
mySpacingRaw' = spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True

myFull = renamed [Replace "Full"]
            $ noBorders (Full)

myTiled = renamed [Replace "Tall"]
            $ windowNavigation
            $ addTabs shrinkText myTabConfig
            $ mkToggle (single MIRROR)
            $ subLayout [] (smartBorders Simplest)
            $ mySpacingRaw
            $ ResizableTall 1 (3/100) (1/2) []

myTabs = renamed [Replace "Tabbed"]
            $ subLayout [] (smartBorders Simplest)
            $ noBorders (tabbed shrinkText myTabConfig)

myThreeCol = renamed [Replace "ThreeColMid"]
            $ windowNavigation
            $ addTabs shrinkText myTabConfig
            $ subLayout [] (smartBorders Simplest)
            $ mySpacingRaw
            $ limitWindows 10
            $ ThreeColMid 1 (3/100) (1/2)

myBsp = renamed [Replace "BSP"]
            $ windowNavigation
            $ mySpacingRaw
            $ subLayout [] (smartBorders Simplest)
            $ limitWindows 12
            $ BSP.emptyBSP

myGrid = renamed [Replace "Grid"]
            $ windowNavigation
            $ addTabs shrinkText myTabConfig
            $ subLayout [] (smartBorders Simplest)
            $ mySpacingRaw
            $ limitWindows 8
            $ Grid (16/10)

-- -------------------------------------------------------------------------------------------------------
-- Combine all layouts
-- -------------------------------------------------------------------------------------------------------
-- myLayout = renamed [CutWordsLeft 1] . avoidStruts . minimize $ perWS
myLayout = avoidStruts
            $ mouseResize
            $ windowArrange
            $ mkToggle (NBFULL ?? NOBORDERS ?? EOT)
            $ perWS



-- -------------------------------------------------------------------------------------------------------
-- Mouse bindings
-- -------------------------------------------------------------------------------------------------------
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w))

    -- , ((mySup, 1), (\w -> focus w >> windows W.swapUp))

    -- mod-button 4 & 5
    , ((mySup, button4),               (\_ -> windows W.focusUp))
    , ((mySup, button5),               (\_ -> windows W.focusDown))
    , ((mySup .|. shiftMask, button4), (\_ -> windows W.swapUp))
    , ((mySup .|. shiftMask, button5), (\_ -> windows W.swapDown))
    ]


-- -------------------------------------------------------------------------------------------------------
-- Xmonad commands from dmenu prompt
-- -------------------------------------------------------------------------------------------------------
commands :: X [(String, X ())]
commands = defaultCommands


-- -------------------------------------------------------------------------------------------------------
-- UrgencyHook Config
-- -------------------------------------------------------------------------------------------------------
myUrgencyConfig = urgencyConfig { suppressWhen = Focused
                                ,remindWhen = Every 10
                                }

-- -------------------------------------------------------------------------------------------------------
-- Key mappings
-- -------------------------------------------------------------------------------------------------------

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [
      ((myAlt,                      xK_Return),    spawn $ myTerminal)
    , ((myAlt .|. shiftMask,        xK_Return),    spawn $ "alacritty --class=work -t work -e tmux new-session -A -s WORK")
    , ((myAlt,                      xK_Escape),    spawn $ "xkill")
    , ((myAlt .|. shiftMask ,       xK_c),         kill)

    -- Application menus
    , ((myAlt,                      xK_F11),       spawn $ "rofi -show run -fullscreen -dpi 150" )
    , ((mySup,                      xK_d),         spawn $ "rofi -show drun -lines 10 -columns 1 -width 45 -sidebar-mode -dpi 150" )
    , ((myAlt,                      xK_y),         spawn $ "polybar-msg cmd toggle" )
    , ((mySup .|. shiftMask,        xK_p),         spawn $ "$HOME/.config/polybar/launch-polybar.sh" )
    , ((mySup,  xK_e),                             spawn $ "thunar")

    -- XMonad recompile / restart
    , ((myAlt .|. shiftMask,        xK_r),         spawn $ "xmonad --recompile && xmonad --restart")
    , ((mySup,                      xK_r),         spawn $ "xmonad --restart")
    , ((myAlt .|. controlMask,      xK_u),         spawn $ "pavucontrol")
    , ((myAlt .|. shiftMask,        xK_e),         spawn $ "$HOME/.config/scripts/bspwm-dmenu-actions.sh")

    , ((0,                         xK_Print),      spawn $ "flameshot gui")
    , ((0 .|. shiftMask,           xK_Print ),     spawn $ "shutter -s")

    , ((0, xF86XK_AudioMute),                      spawn $ "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ((0, xF86XK_AudioMicMute),                   spawn $ "amixer set Capture toggle")
    , ((0, xK_F12),                                spawn $ "amixer set Capture toggle" )
    , ((0, xF86XK_AudioLowerVolume),               spawn $ "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ((0, xF86XK_AudioRaiseVolume),               spawn $ "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ((0, xF86XK_MonBrightnessUp),                spawn $ "xbacklight -inc 5")
    , ((0, xF86XK_MonBrightnessDown),              spawn $ "xbacklight -dec 5")

    -- Submap key bindings

    , ((myAlt, xK_o), submap . M.fromList $
        [ ((0, xK_p),     spawn "pavucontrol")
        , ((0, xK_f),     spawn "firefox")
        , ((0, xK_a),     spawn myTerminal)
        , ((0, xK_g),     spawn "gvim")
        , ((0, xK_w),     spawn "VBoxManage startvm Windows10 --type gui")
        , ((0, xK_v),     spawn "virtualbox")
        ])

    , ((myAlt, xK_l), submap . M.fromList $
        [ ((0, xK_f),     sendMessage $ JumpToLayout "Full"       )
        , ((0, xK_t),     sendMessage $ JumpToLayout "Tabbed"     )
        , ((0, xK_l),     sendMessage $ JumpToLayout "Tall"       )
        , ((0, xK_g),     sendMessage $ JumpToLayout "Grid"       )
        , ((0, xK_c),     sendMessage $ JumpToLayout "ThreeColMid")
        , ((0, xK_b),     sendMessage $ JumpToLayout "BSP")
        ])

    -- scratchpads
    , ((myAlt, xK_u),     namedScratchpadAction myScratchpads "terminal")
    , ((0,     xK_F2),    spawn $ "xfce4-appfinder")


    -- ---------------------------------------------------------------------------------------------------
    --  XMONAD LAYOUT KEYS
    -- ---------------------------------------------------------------------------------------------------

    -- Quit xmonad
    , ((myAlt .|. shiftMask, xK_q),        io (exitWith ExitSuccess))
    , ((mySup,               xK_space),    sendMessage NextLayout)             -- switch layout
    , ((myAlt .|. shiftMask, xK_space ),   setLayout $ XMonad.layoutHook conf) -- reset to default layout
    , ((mySup,               xK_Tab),      windows W.focusDown)

    -- CycleWS setup
    , ((myAlt,               xK_Tab),      toggleWS)                             -- toggle workspaces focus
    , ((myAlt,               xK_n),        moveTo  Next nonNSP)                  -- next workspace
    , ((myAlt,               xK_p),        moveTo  Prev nonNSP)                  -- previous workspace
    , ((myAlt .|. shiftMask, xK_n),        shiftTo Next nonNSP)                  -- shift to next workspace
    , ((myAlt .|. shiftMask, xK_p),        shiftTo Prev nonNSP)                  -- shift to prev workspace
    , ((mySup .|. shiftMask, xK_n),        shiftNextScreen)                      -- shift to next screen
    , ((mySup .|. shiftMask, xK_p),        shiftPrevScreen)                      -- shift to previous screen
    , ((myAlt,               xK_e),        nextScreen >> myUpdatePointerCenter)  -- shift to previous screen

    -- Push window back into tiling.
    , ((myAlt, xK_space), toggleFloat)

    -- ---------------------------------------------------------------------------------------------------
    -- Window / Workspaces navigaton
    -- ---------------------------------------------------------------------------------------------------

    , ((myAlt,                 xK_j),      windows W.focusDown)
    , ((myAlt,                 xK_k),      windows W.focusUp)
    , ((myAlt .|. shiftMask,   xK_m),      windows W.focusMaster)
    , ((myAlt .|. shiftMask,   xK_j),      windows W.swapDown)
    , ((myAlt .|. shiftMask,   xK_k),      windows W.swapUp)

    -- Shrink / Expand the master area
    , ((myAlt .|. shiftMask ,  xK_h),      sendMessage Shrink)
    , ((myAlt .|. shiftMask ,  xK_l),      sendMessage Expand)

    -- WindowNavigation
    , ((myAlt,                 xK_Right),  sendMessage $ Go R)
    , ((myAlt,                 xK_Left ),  sendMessage $ Go L)
    , ((myAlt,                 xK_Up   ),  sendMessage $ Go U)
    , ((myAlt,                 xK_Down ),  sendMessage $ Go D)
    , ((myAlt .|. controlMask, xK_Right),  sendMessage $ Swap R)
    , ((myAlt .|. controlMask, xK_Left ),  sendMessage $ Swap L)
    , ((myAlt .|. controlMask, xK_Up   ),  sendMessage $ Swap U)
    , ((myAlt .|. controlMask, xK_Down ),  sendMessage $ Swap D)

    -- Sub Layouts commands
    , ((mySup .|. controlMask, xK_h),      sendMessage $ pullGroup L)
    , ((mySup .|. controlMask, xK_l),      sendMessage $ pullGroup R)
    , ((mySup .|. controlMask, xK_k),      sendMessage $ pullGroup U)
    , ((mySup .|. controlMask, xK_j),      sendMessage $ pullGroup D)
    , ((mySup .|. controlMask, xK_u),      withFocused (sendMessage . UnMerge))
    , ((mySup .|. controlMask, xK_m),      withFocused (sendMessage . MergeAll))
    , ((mySup .|. controlMask, xK_slash),  withFocused (sendMessage . UnMergeAll))
    , ((mySup,                 xK_k),      onGroup W.focusUp')
    , ((mySup,                 xK_j),      onGroup W.focusDown')

    -- Increment / decrement the number of windows in the master area.
    , ((myAlt .|. controlMask, xK_Left),   sendMessage (IncMasterN 1))
    , ((myAlt .|. controlMask, xK_Right),  sendMessage (IncMasterN (-1)))

    -- XMonad.Layout.MultiToggle
    , ((myAlt, xK_f),                      sendMessage $ MT.Toggle NBFULL)          -- set fullscreen no borders
    , ((myAlt, xK_r),                      sendMessage $ MT.Toggle MIRROR)          -- mirror layout
    , ((myAlt, xK_g),                      spawn "rofi -show window -dpi 150")      -- focus windows
    , ((myAlt .|. shiftMask, xK_b),        bringMenuConfig myWindowBringerConfig  ) -- bring windows to the current workspace
    , ((myAlt .|. controlMask, xK_y),      commands >>= runCommand)                 -- select xmonad commands from dmenu
    , ((mySup, xK_s),                      sendMessage ToggleStruts >> spawn "polybar-msg cmd toggle")                -- toggle struts

    ]

    ++
    -- mod-[1..9],       Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. myAlt, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]

    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
    , (\i -> W.greedyView i . W.shift i, shiftMask)]
    ]

    ++
    -- ctrl-{comma,period,minus},       Switch to physical/Xinerama screens 1, 2, or 3
    -- ctrl-shift-{comma,period,minus}, Move client to screen 1, 2, or 3
    [((m .|. myAlt, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_period, xK_comma, xK_minus] [0..]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]


-- -------------------------------------------------------------------------------------------------------
-- Additional Keys (simple form)
-- -------------------------------------------------------------------------------------------------------
-- Additional keys
-- M4 == Sup
-- M  == Alt
myAdditionalKeys =
    -- copy window to specific workspaces (dwm tag like) with MOD-CTRL-SHIFT-[0-9]
    [("M-" ++ m ++ k, windows $ f i)
        | (i, k) <- zip (myWorkspaces) (map show [1 :: Int ..])
        , (f, m) <- [(W.greedyView, ""), (W.shift, "S-"), (copy, "S-C-")]
    ]
    ++
    [ ("S-C-a", windows copyToAll)   -- copy window to all workspaces
    , ("S-C-z", killAllOtherCopies)  -- kill copies of window on other workspaces
    , ("M4-a",  sendMessage MirrorExpand)
    , ("M4-z",  sendMessage MirrorShrink)
    ]


-- execute when xmonad starts
myStartupHook = do
    spawn "$HOME/.config/xmonad/autostart.sh"
    -- spawnOnce = "start-pulseaudio-x11; pulseaudio --start"
    -- spawnOnce = "nm-applet"
    -- spawnOnce = "blueman-applet"
    -- spawnOnce = "/opt/dropbox/dropboxd"
    -- spawnOnce = "/usr/lib/xfce4/notifyd/xfce4-notifyd"
    -- spawnOnce = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
    setWMName "LG3D"
    -- spawnOn myWS1 "alacritty --class=work -t work -e tmux new-session -A -s WORK"
    -- spawnOn myWS2 myBrowser


-- -------------------------------------------------------------------------------------------------------
-- MAIN FUNCTION
-- -------------------------------------------------------------------------------------------------------
main :: IO ()
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    xmonad
        $ withUrgencyHookC NoUrgencyHook myUrgencyConfig
        $ ewmh
        $ myBaseConfig {
            startupHook          = myStartupHook
            , layoutHook         = myLayout
            , manageHook         = manageDocks
                                    <+> (isFullscreen --> doFullFloat)
                                    <+> manageSpawn -- manage startupHook spawnOn
                                    <+> myManageHook
                                    <+> manageHook myBaseConfig
            , modMask            = myModMask
            , borderWidth        = myBorderWidth
            , handleEventHook    = serverModeEventHookCmd
                                    <+> serverModeEventHook
                                    <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                                    <+> docksEventHook
                                    <+> fullscreenEventHook
                                    <+> ewmhDesktopsEventHook
                                    <+> handleEventHook myBaseConfig
            , focusFollowsMouse  = myFocusFollowsMouse
            , workspaces         = myWorkspaces
            , focusedBorderColor = myFocusedBorderColor
            , normalBorderColor  = myNormalBorderColor
            , keys               = myKeys
            , logHook            = workspaceHistoryHook
                                    <+> dynamicLogWithPP (myLogHook dbus) >> myUpdatePointerCenter
            , mouseBindings      = myMouseBindings
        } `additionalKeysP` myAdditionalKeys



-- -------------------------------------------------------------------------------------------------------
-- Log Hook
-- -------------------------------------------------------------------------------------------------------
-- %{F} == polybar foreground
-- %{B} == polybar background
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
    , ppLayout           = wrap "%{A1:xdotool key super+space &:}\63564 " "%{A}"
    , ppTitle            = myAddSpaces 30
    -- , ppExtras          = [logCmd "echo ASD", windowCount]
    , ppExtras           = [wrapL "%{A1:rofi -show window -dpi 150 &:}\62162 " "%{A}" windowCount]
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


-- -------------------------------------------------------------------------------------------------------
-- Toggle floating window in the center
-- -------------------------------------------------------------------------------------------------------
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


-- -------------------------------------------------------------------------------------------------------
-- Window Count
-- -------------------------------------------------------------------------------------------------------
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset


-- -------------------------------------------------------------------------------------------------------
-- Update mouse pointer to the center of the focused window
-- -------------------------------------------------------------------------------------------------------
myUpdatePointerCenter = updatePointer (0.5, 0.5) (0, 0)


-- -------------------------------------------------------------------------------------------------------
-- WindowBringer
-- -------------------------------------------------------------------------------------------------------
myWindowBringerConfig :: WindowBringerConfig
myWindowBringerConfig = def
    { menuCommand = "rofi"
    , menuArgs = ["-dmenu", "-show-icons", "-dpi 150", "-i"]
    , windowTitler = myWindowBringerTitler
    }
myWindowBringerColumnSize = 50

myWindowBringerTitler :: WindowSpace -> Window -> X String
myWindowBringerTitler ws w = do
    description <- show <$> getName w
    return $ descriptionToLine description

descriptionToLine :: String -> String
descriptionToLine d =
  let (name, title) = splitInformation d
      name' = fillWithSpaces myWindowBringerColumnSize name
   in name' ++ title

fillWithSpaces len str
  | ls < len = str ++ replicate (len -  ls) ' '
  | otherwise = str
  where
    ls = length str

splitInformation :: String -> (String, String)
splitInformation d = mapTuple (T.unpack . T.reverse . T.strip . T.pack) $ span (/= '-') (reverse d)

mapTuple :: (a -> b) -> (a, a) -> (b, b)
mapTuple f (a, b) = (f a, f b)


-- filter NSP workspace
nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

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
