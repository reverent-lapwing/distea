module Bracket.Elimination(chooseEntryIO) where

import Core.Data
import Bracket.Bracket

import Data.Monoid
import Control.Monad (ap)

data Alternative a = Two a a (Alternative a) | One a | Null

instance Bracket Alternative where
    reduce (Two x y xs) (All True)  = xs <> (One x)
    reduce (Two x y xs) (All False) = xs <> (One y)
    reduce (One x)       _          = One x
    reduce Null          _          = Null

instance Semigroup (Alternative a) where
    (<>) x            Null         = x
    (<>) Null         x            = x
    (<>) (One x)      (One y)      = Two x y Null
    (<>) (One x)      (Two y z xs) = Two x y (One z <> xs)
    (<>) (Two x y xs) x'           = Two x y (xs <> x')

instance Monoid (Alternative a) where
    mempty = Null

instance Functor Alternative where
    fmap _ Null         = Null
    fmap f (One x)      = (One (f x))
    fmap f (Two x y xs) = (Two (f x) (f y) (fmap f xs))

instance Foldable Alternative where
    foldMap f Null         = mempty
    foldMap f (One x)      = f x
    foldMap f (Two x y xs) = f x <> f y <> (foldMap f xs)

instance Applicative Alternative where
    pure x = One x
    (<*>) = ap
     
instance Monad Alternative where
    (>>=) Null         _  = Null
    (>>=) (One x)      f = f x
    (>>=) (Two x y xs) f = f x <> f y <> (xs >>= f)

chooseEntryIO :: Monoid a => ([ a ] -> IO Choice) -> [ a ] -> IO a
chooseEntryIO f x = (reduceEntriesIO f) $ makeBracket x


reduceEntriesIO :: (Monoid a) => ([ a ] -> IO Choice) -> Alternative a -> IO a
reduceEntriesIO _ Null    = return mempty
reduceEntriesIO _ (One x) = return x
reduceEntriesIO f x       = f (getChoices x) >>= (reduceEntriesIO f) . (reduce x)

