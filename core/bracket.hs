module Core.Bracket where

import Core.Data

class Bracket a where
    reduce :: (String -> IO Choice) -> a -> IO a
{-
    reduceEntries :: (String -> IO Choice) -> [ a ] -> IO Entry
    prepareBrackets :: [ Entry ] -> [ a ]
    chooseEntry :: (String -> IO Choice) -> [ Entry ] -> IO Entry
    chooseEntry f x = (reduceEntries f) $ prepareBrackets x
-}