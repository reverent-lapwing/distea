module Bracket.Elimination(chooseEntryIO) where

import Core.Data
import Bracket.Bracket

import Data.Monoid
import Data.Foldable
import Control.Monad (ap)

type Elimination a = [a]

instance Bracket [] where
    reduce x (All True)  = (((take 1) . id      . (take 2)) l) <> (drop 2 l) where l = toList x
    reduce x (All False) = (((take 1) . reverse . (take 2)) l) <> (drop 2 l) where l = toList x

chooseEntryIO :: Monoid a => ([ a ] -> IO Choice) -> [ a ] -> IO a
chooseEntryIO f x = (reduceEntriesIO f) $ makeBracket x


reduceEntriesIO :: (Monoid a) => ([ a ] -> IO Choice) -> Elimination a -> IO a
reduceEntriesIO _ []  = return mempty
reduceEntriesIO _ [x] = return x
reduceEntriesIO f x   = f (getChoices x) >>= (reduceEntriesIO f) . (reduce x)

