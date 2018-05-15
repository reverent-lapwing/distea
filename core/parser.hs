module Core.Parser where

import Core.Data

splitEntries :: String -> [ Entry ]
splitEntries [] = []
splitEntries x = (\(a,b) -> [ a ] ++ (splitEntries (drop 1 b))) (break (== ',') x)

parseChoice :: String -> Maybe Choice
parseChoice "l" = Just True
parseChoice "r" = Just False
parseChoice _ = Nothing


        
