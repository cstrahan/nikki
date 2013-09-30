{-# language DeriveDataTypeable #-}

module Base.Configuration.Controls (

    Controls,
    leftKey,
    rightKey,
    upKey,
    downKey,
    jumpKey,
    contextKey,
    KeysHint(..),
    isFullscreenSwapShortcut,
    keysContext,

    -- * menu
    isMenuUp,
    isMenuDown,
    isMenuConfirmation,
    isMenuBack,
    menuKeysHint,
    menuConfirmationKeysHint,
    scrollableKeysHint,
    gameNikkiKeysHint,
    gameTerminalKeysHint,
    gameRobotKeysHint,

    -- * text fields
    isTextFieldConfirmation,
    isTextFieldBack,

    -- * game
    isGameLeftHeld,
    isGameRightHeld,
    isGameJumpHeld,
    isGameLeftPressed,
    isGameRightPressed,
    isGameJumpPressed,
    isGameContextPressed,
    isGameBackPressed,

    -- * terminals
    isTerminalConfirmationPressed,

    -- * robots
    isRobotActionHeld,
    isRobotActionPressed,
    isRobotBackPressed,

    -- * editor
    isEditorA,
    isEditorB,

  ) where


import Data.Data
import Data.Initial
import Data.Accessor
import Data.Char (toUpper)

import Control.Arrow

import System.Info

import Graphics.Qt

import Utils

import Base.Types.Events
import Base.Prose
import Base.Prose.Template


-- | Configuration of controls
-- Uses versioned constructors (is saved as part of the configuration).

data Controls = Controls_0 {
    leftKey_ :: (Key, String),
    rightKey_ :: (Key, String),
    upKey_ :: (Key, String),
    downKey_ :: (Key, String),
    jumpKey_ :: (Key, String),
    contextKey_ :: (Key, String)
  }
    deriving (Show, Read, Typeable, Data)

leftKey, rightKey, upKey, downKey, jumpKey, contextKey :: Accessor Controls (Key, String)
leftKey = accessor leftKey_ (\ a r -> r{leftKey_ = a})
rightKey = accessor rightKey_ (\ a r -> r{rightKey_ = a})
upKey = accessor upKey_ (\ a r -> r{upKey_ = a})
downKey = accessor downKey_ (\ a r -> r{downKey_ = a})
jumpKey = accessor jumpKey_ (\ a r -> r{jumpKey_ = a})
contextKey = accessor contextKey_ (\ a r -> r{contextKey_ = a})

instance Initial Controls where
    initial = Controls_0 {
        leftKey_ = mkKey LeftArrow,
        rightKey_ = mkKey RightArrow,
        upKey_ = mkKey UpArrow,
        downKey_ = mkKey DownArrow,
        jumpKey_ = initialJumpKey,
        contextKey_ = mkKey Shift
      }
        where
            mkKey k =
                (k, keyDescription k (error "please don't use the given key text"))
            initialJumpKey = case System.Info.os of
                "darwin" -> mkKey Space -- Ctrl+Arrows clashes with default shortcuts for virtual desktops on osx.
                _ -> mkKey Ctrl

-- | represents hints for keys for user readable output
data KeysHint
    = KeysHint {keysHint :: [(Prose, Prose)]}
    | PressAnyKey


-- * context for templates

keysContext :: Controls -> [(String, String)]
keysContext controls = map (second (mkKeyString controls)) $ (
    ("leftKey", leftKey) :
    ("rightKey", rightKey) :
    ("upKey", upKey) :
    ("downKey", downKey) :
    ("jumpKey", jumpKey) :
    ("contextKey", contextKey) :
    [])

mkKeyString :: Controls -> Accessor Controls (Key, String) -> String
mkKeyString controls acc =
    map toUpper $
    snd (controls ^. acc)

-- * internals

isKey :: Key -> (Button -> Bool)
isKey a (KeyboardButton b _ _) = a == b
isKey _ _ = False

isKeyWS :: (Key, String) -> (Button -> Bool)
isKeyWS = isKey . fst


-- ** externals

isFullscreenSwapShortcut :: Button -> Bool
isFullscreenSwapShortcut k =
    ((isKey Enter k || isKey Return k) && fany (== AltModifier) (keyModifiers k)) ||
    (isKey F11 k)


-- * Menu

isMenuUp, isMenuDown, isMenuConfirmation, isMenuBack :: Controls -> Button -> Bool
isMenuUp _ = isKey UpArrow
isMenuDown _ = isKey DownArrow
isMenuConfirmation controls k =
    isKey Return k ||
    isKey Enter k ||
    isConfiguredMenuKey controls jumpKey k
isMenuBack controls k =
    isKey Escape k ||
    isConfiguredMenuKey controls contextKey k

-- | Returns, if a given key is the key specified by the given Controls-selector
-- AND if it does not shadow any other menu keys.
isConfiguredMenuKey :: Controls -> (Accessor Controls (Key, String)) -> Button -> Bool
isConfiguredMenuKey controls selector b =
    not (shadowsMenuButton b) &&
    isKeyWS (controls ^. selector) b

shadowsMenuButton :: Button -> Bool
shadowsMenuButton (KeyboardButton k _ _) = k `elem` (
    UpArrow :
    DownArrow :
    Return :
    Enter :
    Escape :
    [])


-- | user readable hints which keys to use
menuKeysHint :: Bool -> KeysHint
menuKeysHint acceptsBackKey = KeysHint (
    (p "select", p "↑↓") :
    keysHint (menuConfirmationKeysHint (p "confirm")) ++
    (if acceptsBackKey then [(p "back", p "esc")] else []) ++
    [])

menuConfirmationKeysHint :: Prose -> KeysHint
menuConfirmationKeysHint text = KeysHint (
    (text, p "⏎") :
    [])

-- | keys hint for Base.Renderable.Scrollable
scrollableKeysHint :: KeysHint
scrollableKeysHint = KeysHint (
    (p "scroll", pv "↑↓") :
    (p "back", p "any key") :
    [])

gameNikkiKeysHint :: Controls -> KeysHint
gameNikkiKeysHint controls = KeysHint $ map (second (substitute (keysContext controls))) $ (
    (p "walk", p "$leftKey$rightKey") :
    (p "jump", p "$jumpKey") :
    (p "context key", p "$contextKey") :
    [])

gameTerminalKeysHint :: Controls -> KeysHint
gameTerminalKeysHint controls = KeysHint $ map (second (substitute (keysContext controls))) $ (
    (p "select", p "$leftKey$rightKey") :
    (p "confirm", p "$jumpKey") :
    [])

gameRobotKeysHint :: Controls -> KeysHint
gameRobotKeysHint controls = KeysHint $ map (second (substitute (keysContext controls))) $ (
    (p "controls", p "$leftKey$rightKey$upKey$downKey and $jumpKey") :
    (p "back", p "$contextKey") :
    [])


-- * text fields

isTextFieldBack, isTextFieldConfirmation :: Button -> Bool
isTextFieldBack = isKey Escape
isTextFieldConfirmation k = isKey Return k || isKey Enter k


-- * game

isGameLeftHeld, isGameRightHeld, isGameJumpHeld :: Controls -> ControlData -> Bool
isGameLeftHeld controls = fany (isKeyWS (controls ^. leftKey)) . held
isGameRightHeld controls = fany (isKeyWS (controls ^. rightKey)) . held
isGameJumpHeld controls = fany (isKeyWS (controls ^. jumpKey)) . held

isGameLeftPressed, isGameRightPressed, isGameJumpPressed, isGameContextPressed,
    isGameBackPressed
    :: Controls -> ControlData -> Bool
isGameLeftPressed controls = fany (isKeyWS (controls ^. leftKey)) . pressed
isGameRightPressed controls = fany (isKeyWS (controls ^. rightKey)) . pressed
isGameJumpPressed controls = fany (isKeyWS (controls ^. jumpKey)) . pressed
isGameContextPressed controls = fany (isKeyWS (controls ^. contextKey)) . pressed
isGameBackPressed _ = fany (isKey Escape) . pressed


-- * terminals

isTerminalConfirmationPressed :: Controls -> ControlData -> Bool
isTerminalConfirmationPressed controls =
    fany is . pressed
  where
    is k = isKeyWS (controls ^. jumpKey) k ||
           isMenuConfirmation controls k


-- * robots (in game)

isRobotActionHeld :: Controls -> ControlData -> Bool
isRobotActionHeld controls = fany (isKeyWS (controls ^. jumpKey)) . held

isRobotActionPressed, isRobotBackPressed :: Controls -> ControlData -> Bool
isRobotActionPressed controls = fany (isKeyWS (controls ^. jumpKey)) . pressed
isRobotBackPressed controls = fany (isKeyWS (controls ^. contextKey)) . pressed


-- * editor

-- Most of the editor keys are hardcoded.

isEditorA, isEditorB :: Key -> Bool
isEditorA = (== Ctrl)
isEditorB = (== Shift)
