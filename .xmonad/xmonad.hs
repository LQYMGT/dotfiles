import XMonad
import XMonad.Util.EZConfig
import XMonad.Layout.ResizableTile
import XMonad.Util.Cursor
-- banish
import XMonad.Actions.Warp
-- scratchpad
import XMonad.Util.Scratchpad
import qualified XMonad.StackSet as W
-- IM
import XMonad.Layout.IM
import Data.Ratio ((%))

-- currentWs
import XMonad.Hooks.ManageHelpers

defaultLayouts =  withIM (1%7) (ClassName "Pidgin") (ResizableTall 1 (3/100) (1/2) [])

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myManageHook = composeAll
   [ className =? "Emacs" --> doShift "1"
   , className =? "Firefox" --> doShift "7"
--   , className =? "Chromium" --> doShift "7"
   , className =? "Google-chrome-stable" --> doShift "7"
   , className =? "Fqterm.bin" --> doShift "8"
   , className =? "Skype" --> doShift "9"
   , className =? "Steam" --> doShift "9"
   , className =? "Pidgin" --> doShift "2"
   , className =? "Thunderbird" --> doShift "3"
   , className =? "Eclipse" --> doShift "4"
   , className =? "Java" --> doShift "4"
   , className =? "jetbrains-android-studio" --> doShift "4"
--   , currentWs =? "9" --> doFloat
   , className =? "Pavucontrol" --> doFloat
   , className =? "feh" --> doFloat
   , className =? "Sxiv" --> doFloat
   ]

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
  where

    h = 0.48    -- terminal height
    w = 0.45     -- terminal width
    t = 0       -- distance from top edge
    l = 1-w     -- distance from left edge

myTerminal = "urxvt"

myStartupHook = do
  setDefaultCursor xC_left_ptr
  spawn "feh --bg-scale Pictures/elememtary/OurNightUnderTheStars.jpg"

main = do
   xmonad $ defaultConfig
                         {terminal     = myTerminal
                         , modMask     = mod4Mask
                         , borderWidth = 1
                         , layoutHook  = defaultLayouts
                         , manageHook  = myManageHook <+> manageScratchPad
                         , workspaces  = myWorkspaces
                         , startupHook = myStartupHook
                         }
     `additionalKeysP`
     [ ("M-e", spawn "emacsclient -c")
     , ("M-a", spawn "synclient TouchPadOff=1")
     , ("M-S-a", spawn "synclient TouchPadOff=0")
     , ("M-v", spawn "pavucontrol")
     , ("M-o", banishScreen LowerRight)
     , ("M-d", sendMessage MirrorShrink) -- %! Shrink a slave area
     , ("M-u", sendMessage MirrorExpand) -- %! Expand a slave area
     , ("M-z", scratchPad)
     , ("M-<Backspace>", spawn "xscreensaver-command --lock")
     ]
     where 
       scratchPad = scratchpadSpawnActionTerminal myTerminal
