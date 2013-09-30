#!/usr/bin/env runhaskell --version


import Data.Initial

import Control.Monad

import System.Directory
import System.FilePath

import Base

import Editor.Pickle
import Editor.Pickle.Types


main = do
    exists <- doesDirectoryExist dir
    when (not exists) $
        error (dir ++ " does not exist")
    let path = dir </> "empty.nl"
    putStrLn ("writing empty level to " ++ show path)
    writeSaved path $ pickle $
        DiskLevel initial Nothing


dir = "../../data/templateLevels"

