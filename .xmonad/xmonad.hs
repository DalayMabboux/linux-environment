import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.ManageDocks (ToggleStruts(..),avoidStruts,docks,manageDocks)
import XMonad.Layout.Spacing
import XMonad.Actions.SpawnOn
import XMonad.Actions.GroupNavigation
import qualified XMonad.StackSet as W
import XMonad.Layout.Tabbed
import XMonad.Layout.Circle
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Hooks.SetWMName (setWMName)

-- Color of current window title in xmobar.
xmobarTitleColor = "#EAAA31"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#FF6600"

myWorspaces = ["1:work", "2:div"]

myStartupHook = do
  spawnOn "1:work" "firefox"
  spawnOn "1:work" "gnome-terminal"
  spawn "xcompmgr -cfF -t-9 -l-11 -r9 -o.95 -D6 &"
  spawn "feh --bg-scale $HOME/Documents/alien_evolution.jpg"
  setWMName "LG3D"

myLayout = tiled
           ||| Full
           ||| threeCol
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = ResizableTall nmaster delta ratio []
     threeCol = ThreeColMid nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 2/100

myFocusedBorderColor = "#268bd2"

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ def
      { modMask            = mod1Mask
      , borderWidth        = 3
      , terminal           = "gnome-terminal"
      , manageHook         = manageDocks <+> manageHook defaultConfig
      , layoutHook         = smartSpacing 5 $ avoidStruts  $ myLayout
      -- this must be in this order, docksEventHook must be last
      , handleEventHook    = handleEventHook defaultConfig <+> docksEventHook
      , workspaces         = myWorspaces
      , startupHook        = myStartupHook
      , focusedBorderColor = myFocusedBorderColor
      , logHook            = dynamicLogWithPP xmobarPP
          { ppOutput          = hPutStrLn xmproc
          , ppTitle           = xmobarColor "darkgreen"  "" . shorten 20
          , ppHiddenNoWindows = xmobarColor "grey" ""
          } >> historyHook
      } `additionalKeys`
      [ ((mod1Mask,  xK_b), sendMessage ToggleStruts)
      , ((mod1Mask, xK_Tab), nextMatch History (return True))
      , ((mod1Mask, xK_f), sendMessage MirrorShrink)
      , ((mod1Mask, xK_d), sendMessage MirrorExpand)
      ]

