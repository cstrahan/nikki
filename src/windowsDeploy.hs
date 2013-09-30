#!/usr/bin/env runhaskell


import Control.Monad

import System.Environment
import System.Directory
import System.Process
import System.FilePath
import System.Exit

import Utils.Scripting


deploymentDir = "nikki"


main = do
    args <- filterM warnWhenNotDirectory =<< getArgs
    let searchPath = args ++ ["dist/build/nikki/", "dist/build/core/", "../"]
    clean
    copy searchPath
    let deploymentIndicator = deploymentDir </> "yes_nikki_is_deployed"
    copyLicenses
    putStrLn ("touching " ++ deploymentIndicator)
    writeFile deploymentIndicator ""

failWithUsage = do
    putStrLn ""
    putStrLn =<< readFile "windowsDeploy.readme"
    exitWith $ ExitFailure 3

-- | Checks, if a directory exists and issues a warning, when not.
-- Returns if the directory exists.
warnWhenNotDirectory :: FilePath -> IO Bool
warnWhenNotDirectory p = do
    e <- doesDirectoryExist p
    when (not e) $
        putStrLn ("WARNING: directory does not exist: " ++ p)
    return e

-- | cleans the deployed folder
-- creates the deployment folder, if ot doesn't exist
clean :: IO ()
clean = do
    putStrLn "cleaning..."
    exists <- doesDirectoryExist deploymentDir
    if exists then do
        _ <- system ("rm -rf " ++ deploymentDir ++ "/*")
        return ()
      else
        createDirectory deploymentDir

-- | copies all files to the deployment folder
copy :: [FilePath] -> IO ()
copy searchPath = do
    putStrLn "copying..."
    mapM_ (\ file -> searchAndCopy searchPath file deploymentDir) deploymentFiles

-- | searches for a files in the given searchpath and copies it to the destination folder

searchAndCopy :: [FilePath] -> FilePath -> FilePath -> IO ()
searchAndCopy searchPath file destinationFolder = do
    mSrc <- search searchPath file
    case mSrc of
        Just src -> do
            putStrLn ("found " ++ file ++ " in " ++ takeDirectory src)
            trySystem ("cp -r " ++ src ++ " " ++ destinationFolder)
            return ()
        Nothing -> do
            putStrLn ("ERROR: file not found in searched paths: " ++ file)
            failWithUsage

-- | searches a file in a given list of directories
-- and returns the full (albeit not necessarily absolute) path.
search :: [FilePath] -> FilePath -> IO (Maybe FilePath)
search (a : searchPath) file = do
    e <- doesExist (a </> file)
    if e then
        return $ Just (a </> file)
      else
        search searchPath file
search [] _ = return Nothing

doesExist :: FilePath -> IO Bool
doesExist path = do
    a <- doesDirectoryExist path
    b <- doesFileExist path
    return (a || b)

-- | files to deploy
deploymentFiles :: [FilePath]
deploymentFiles = (
    "nikki.exe" :
    "core.exe" :
    "data" :

    -- curl
--     "libcurl-4.dll" : -- shouldn't be needed anymore

    -- are sometimes statically linked
    "libzip.dll" :
    "libzlib1.dll" :
    
    -- sfml deps
    "libsndfile-1.dll" :
    "openal32.dll" :
    
    -- qt
    "QtCore4.dll" :
    "QtGui4.dll" :
    "QtOpenGL4.dll" :
    
    -- mingw deps
    "mingwm10.dll" :
    "libgcc_s_dw2-1.dll" :
    "libstdc++-6.dll" :
    [])
    
-- | copy the needed licenses to the deployment folder
copyLicenses :: IO ()
copyLicenses = do
    putStrLn "copying license files"
    copyDirectory (".." </> "deploymentLicenses") deploymentDir
