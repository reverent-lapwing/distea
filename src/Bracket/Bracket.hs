module Bracket.Bracket where

import Data.Foldable

import Core.Data

class (Foldable a, Applicative a) => Bracket a where
    reduce :: a b -> Choice -> a b
    
    getChoices :: a b -> [ b ]
    getChoices = take 2 . toList

    --getOptions = [ Choice -> b ]
 
    makeBracket :: ( Monoid (a b)) => [ b ] -> a b
    makeBracket = mconcat . (fmap pure)
    
{-
    reduceEntries :: (String -> IO Choice) -> [ a ] -> IO Entry
    prepareBrackets :: [ Entry ] -> [ a ]
    chooseEntry :: (String -> IO Choice) -> [ Entry ] -> IO Entry
    chooseEntry f x = (reduceEntries f) $ prepareBrackets x
-}
