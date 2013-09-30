
module Base.Polling where


import Data.IORef
import Data.StrictList

import Control.Concurrent
import Control.Arrow

import System.IO.Unsafe

import Graphics.Qt

import Utils

import Base.Types
import Base.GlobalShortcuts


-- this is for joystick (and gamepad) stuff, will be used soon!
type JJ_Event = ()

{-# NOINLINE keyStateRef #-}
keyStateRef :: IORef ([AppEvent], SL Button) -- SL Button will be sorted and have
-- unique entries (regarding the Eq-instance).
keyStateRef = unsafePerformIO $ newIORef ([], Empty)

-- | non-blocking polling of AppEvents
-- Also handles global shortcuts.
pollAppEvents :: Application -> M ControlData
pollAppEvents app = do
    (unpolledEvents, keyState) <- io $ readIORef keyStateRef
    qEvents <- io $ pollEvents $ keyPoller app
    appEvents <- handleGlobalShortcuts app $
        map (toAppEvent keyState . Left) qEvents
    let keyState' = foldr (>>>) id (map updateKeyState appEvents) keyState
    io $ writeIORef keyStateRef ([], keyState')
    return $ ControlData (unpolledEvents ++ appEvents) keyState'

-- | puts AppEvents back to be polled again
unpollAppEvents :: [AppEvent] -> IO ()
unpollAppEvents events = do
    (unpolledEvents, keyState) <- readIORef keyStateRef
    writeIORef keyStateRef (unpolledEvents ++ events, keyState)

resetHeldKeys :: IO ()
resetHeldKeys = do
    modifyIORef keyStateRef (second (const Empty))


-- | Blocking wait for the next event.
-- waits between polls
waitForAppEvent :: Application -> M AppEvent
waitForAppEvent app = do
    ControlData events _ <- pollAppEvents app
    case events of
        (a : r) -> io $ do
            unpollAppEvents r
            return a
        [] -> do
            io $ threadDelay (round (0.01 * 10 ^ 6))
            waitForAppEvent app

-- | returns the next AppEvent, if it was already received
nextAppEvent :: Application -> M (Maybe AppEvent)
nextAppEvent app = do
    ControlData events _ <- pollAppEvents app
    case events of
        (a : r) -> io $ do
            unpollAppEvents r
            return $ Just a
        [] -> return Nothing

-- | PRE: SL Button is sorted.
updateKeyState :: AppEvent -> SL Button -> SL Button
updateKeyState (Press   k) = insertUnique k
updateKeyState (Release k) = delete k
updateKeyState Base.Types.FocusOut = const Empty
updateKeyState Base.Types.CloseWindow = id


toAppEvent :: SL Button -> Either QtEvent JJ_Event -> AppEvent
-- keyboard
toAppEvent _ (Left (KeyPress CloseWindowKey _ _)) = Base.Types.CloseWindow
toAppEvent _ (Left (KeyPress key string mods)) = Press $ KeyboardButton key string mods
toAppEvent _ (Left (KeyRelease key string mods)) = Release $ KeyboardButton key string mods

toAppEvent _ (Left Graphics.Qt.FocusOut) = Base.Types.FocusOut
toAppEvent _ (Left Graphics.Qt.CloseWindow) = Base.Types.CloseWindow

-- joystick
-- toAppEvent _ (Right (JoyButtonDown 0 jbutton)) | jbutton `member` jbutton2button =
--     [Press   (jbutton2button ! jbutton)]
-- toAppEvent _ (Right (JoyButtonUp   0 jbutton)) | jbutton `member` jbutton2button =
--     [Release (jbutton2button ! jbutton)]
-- toAppEvent oldButtons (Right (JoyHatMotion  0 0 x)) =
--     calculateJoyHatEvents oldButtons x
