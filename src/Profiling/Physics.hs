{-# language ViewPatterns #-}

module Profiling.Physics (Profiling.Physics.render, terminate) where


import Data.IORef
import Data.Abelian

import Text.Printf

import System.IO
import System.IO.Unsafe

import Graphics.Qt

import Utils

import Base


-- | time window which will be measured
profilingWindow :: POSIXTime
profilingWindow = 1

render :: Application -> Configuration -> Ptr QPainter -> Seconds -> IO ()
render app config ptr spaceTime | physics_profiling config = do
    text <- tick spaceTime
    resetMatrix ptr
    translate ptr (Position (fromUber 1) 0)
    snd =<< Base.render ptr app config zero (False, text)
render _ _ _ _ = return ()

-- | calculate the information to be shown
tick :: Seconds -> IO Prose
tick (realToFrac -> spaceTime) = do
    realTime <- getTime
    (State oldMeasureTime oldDiff oldText log) <- readIORef ref
    if realTime - oldMeasureTime >= profilingWindow then do
        let newDiff = realTime - spaceTime
            diffChange = (newDiff - oldDiff) / profilingWindow
            newText = pVerbatim (printf "Slowdown: %3.1f%%" (realToFrac diffChange * 100 :: Double))
        hPrint log (diffChange * 100)
        writeIORef ref (State realTime newDiff newText log)
        return newText
      else
        return oldText

terminate :: Configuration -> IO ()
terminate config | physics_profiling config = do
    h <- logFile <$> readIORef ref
    hFlush h
    hClose h
terminate _ = return ()

{-# NOINLINE ref #-}
ref :: IORef State
ref = unsafePerformIO $ do
    now <- getTime
    log <- openFile "physicsSlowDown.log" WriteMode
    newIORef (State now (now - 0) (pVerbatim "") log)

data State = State {
    oldMeasureTime :: POSIXTime, -- (POSIX) time of last measurement
    oldDiff :: POSIXTime, -- old difference between POSIX time and space time of the physics engine
    oldText :: Prose,
    logFile :: Handle
  }
