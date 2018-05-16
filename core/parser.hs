module Core.Parser where

import Data.Monoid

import Core.Data

splitEntries :: String -> [ Entry ]
splitEntries [] = []
splitEntries x = (\(a,b) -> [ a ] ++ (splitEntries (drop 1 b))) (break (== ',') x)

parseChoice :: String -> Maybe Choice
parseChoice "l" = Just (All True)
parseChoice "r" = Just (All False)
parseChoice _ = Nothing