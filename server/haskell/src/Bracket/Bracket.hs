module Bracket.Bracket where

import Data.Foldable

import Core.Data

class (Foldable a, Applicative a) => Bracket a where
    reduce :: a b -> Choice -> a b
    
    getChoices :: a b -> [ b ]
    getChoices = take 2 . toList
 
    makeBracket :: ( Monoid (a b)) => [ b ] -> a b
    makeBracket = mconcat . (fmap pure)
    
    reduceEntriesIO :: (Monoid b) => ([ b ] -> IO Choice) -> a b -> IO b
    reduceEntriesIO f entries =
        case choices of
            []    -> return mempty
            x:[]  -> return x
            x:y:_ -> f choices >>= (reduceEntriesIO f) . (reduce entries)
        where choices = getChoices entries
{-
    reduceEntries :: (String -> IO Choice) -> [ a ] -> IO Entry
    prepareBrackets :: [ Entry ] -> [ a ]
    chooseEntry :: (String -> IO Choice) -> [ Entry ] -> IO Entry
    chooseEntry f x = (reduceEntries f) $ prepareBrackets x
-}
