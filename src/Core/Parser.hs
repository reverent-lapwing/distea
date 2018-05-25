module Core.Parser where

import Data.Maybe
import Data.Monoid

import Core.Data

splitEntries :: String -> [ Entry ]
splitEntries [] = []
splitEntries x = (\(a,b) -> [ a ] ++ (splitEntries (drop 1 b))) (break (== ',') x)

showChoices :: [ Entry ] -> Maybe String
showChoices (x:y:xs) = Just ( x ++ " or " ++ y ++ "?" )
showChoices _ = Nothing

parseChoice :: String -> Maybe Choice
parseChoice "l" = Just True
parseChoice "r" = Just False
parseChoice _ = Nothing
