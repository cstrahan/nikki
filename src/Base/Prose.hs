{-# language GeneralizedNewtypeDeriving, ScopedTypeVariables, OverloadedStrings #-}


-- | Module for human readable text.

module Base.Prose (
    Prose(..),
    standardFontColor,
    headerFontColor,
    colorizeProse,
    capitalizeProse,
    getText,
    getString,
    nullProse,
    lengthProse,
    p,
    pVerbatim,
    pv,
    unP,
    pFile,
    zeroSpaceChar,
    watchChar,
    batteryChar,
    switchChar,
    sumSignChar,
    brackets,
  ) where


import Data.Monoid
import Data.Char (chr)
import Data.Text as Text hiding (all)

import Control.Arrow

import Text.Logging

import System.Directory

import Graphics.Qt

import Utils


standardFontColor :: Color = QtColor 70 210 245 255
headerFontColor :: Color = QtColor 36 110 128 255

-- | Type for human readable text.
-- (utf8 encoded)
newtype Prose
    = Prose [(Color, Text)]
  deriving (Show, Monoid)

colorizeProse :: Color -> Prose -> Prose
colorizeProse color p =
    Prose $ return $ tuple color $ getText p

-- | Returns the content of a Prose as a Text.
getText :: Prose -> Text
getText (Prose list) = Prelude.foldr (append) "" $ fmap snd list

getString :: Prose -> String
getString = getText >>> unpack

capitalizeProse :: Prose -> Prose
capitalizeProse (Prose list) =
    Prose $ fmap (second toUpper) list

nullProse :: Prose -> Bool
nullProse (Prose snippets) =
    all Text.null $ fmap snd snippets

lengthProse :: Prose -> Int
lengthProse (Prose snippets) =
    sum $ fmap (Text.length . snd) snippets

-- | Converts haskell Strings to human readable text.
-- Will be used for translations in the future.
p :: String -> Prose
p = pVerbatim

-- | Convert any (ASCII-) string to Prose without doing any translation.
pVerbatim :: String -> Prose
pVerbatim x = Prose [(standardFontColor, pack x)]

-- | shortcut for pVerbatim
pv = pVerbatim

-- | inverse of p
unP :: Prose -> String
unP = getString

-- | Read files and return their content as Prose.
-- Should be replaced with something that supports
-- multiple languages of files.
-- (Needs to be separated from p, because it has to return multiple lines.)
pFile :: FilePath -> IO [Prose]
pFile file = do
    exists <- doesFileExist file
    if exists then
        fmap (Prose . return . tuple standardFontColor) . Text.lines <$> readUnicodeText file
      else do
        logg Error ("file not found: " <> file)
        return $ pure (p "file not found: " <> pv file)

-- | special characters

zeroSpaceChar :: Char
zeroSpaceChar = chr 8203

watchChar :: Char
watchChar = chr 8986

batteryChar :: Char
batteryChar = chr 128267

switchChar :: Char
switchChar = chr 128306

sumSignChar :: Char
sumSignChar = chr 8721

-- | put brackets around a string
brackets :: Prose -> Prose
brackets x =
    pVerbatim "[" <> x <> pVerbatim "]"
