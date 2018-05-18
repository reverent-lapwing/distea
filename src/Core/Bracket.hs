module Core.Bracket where

import Core.Data

class Functor a => Bracket a where
    reduce :: a b -> Choice -> a b
    getChoices :: a b -> [ b ]
    
{-
    reduceEntries :: (String -> IO Choice) -> [ a ] -> IO Entry
    prepareBrackets :: [ Entry ] -> [ a ]
    chooseEntry :: (String -> IO Choice) -> [ Entry ] -> IO Entry
    chooseEntry f x = (reduceEntries f) $ prepareBrackets x
-}