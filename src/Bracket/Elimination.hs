module Bracket.Elimination(chooseEntryIO) where

import Core.Data
import Bracket.Bracket

import Data.Monoid
import Data.Foldable
import Control.Monad (ap)

type Elimination a = [a]

instance Bracket [] where
    reduce x (All True)  = (drop 2 l) <> (((take 1) . id      . (take 2)) l) where l = toList x
    reduce x (All False) = (drop 2 l) <> (((take 1) . reverse . (take 2)) l) where l = toList x

makeElimination :: [ a ] -> Elimination a
makeElimination = makeBracket

chooseEntryIO :: Monoid a => ([ a ] -> IO Choice) -> [ a ] -> IO a
-- Canonic version
--chooseEntryIO f x = (reduceEntriesIO f) $ makeElimination x
-- Simplified version
chooseEntryIO = reduceEntriesIO
