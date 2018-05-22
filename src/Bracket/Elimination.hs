module Tournament.Naive(chooseEntryIO) where

import Core.Data
import Core.Bracket

import Data.Monoid
import Control.Monad (ap)

data Alternative a = Two a a (Alternative a) | One a | Null

instance Bracket Alternative where
    reduce (Two x y xs) (All True)  = mappend xs (One x)
    reduce (Two x y xs) (All False) = mappend xs (One y)
    reduce (One x)       _          = One x
    reduce _             _          = Null
    
    getChoices (Two x y _) = [x,y]
    getChoices (One x)     = [x]
    getChoices _           = []

instance Semigroup (Alternative a) where
    (<>) x            Null         = x
    (<>) Null         x            = x
    (<>) (One x)      (One y)      = Two x y Null
    (<>) (One x)      (Two y z xs) = Two x y (One z <> xs)
    (<>) (Two x y xs) x'           = Two x y (xs <> x')

instance Monoid (Alternative a) where
    mempty = Null

instance Functor Alternative where
    fmap _  Null        = Null
    fmap f (One x)      = (One (f x))
    fmap f (Two x y xs) = (Two (f x) (f y) (fmap f xs))

instance Applicative Alternative where
    pure x = One x
    (<*>) = ap
     
instance Monad Alternative where
    (>>=) Null         _  = Null
    (>>=) (One x)      f = f x
    (>>=) (Two x y xs) f = f x `mappend` f y `mappend` (xs >>= f)

chooseEntryIO :: Monoid a => ([ a ] -> IO Choice) -> [ a ] -> IO a
chooseEntryIO f x = (reduceEntriesIO f) $ makeAlternatives x



altMap :: (Alternative a -> Alternative b) -> Alternative a -> Alternative b
altMap _ Null         = Null
altMap f (One x)      = (f (One x))
altMap f (Two x y xs) = (f (Two x y Null)) `mappend` (altMap f xs)

reduceEntries :: Monoid a => Choice -> Alternative a -> Alternative a
reduceEntries = flip reduce

reduceEntriesIO :: Monoid a => ([ a ] -> IO Choice) -> Alternative a -> IO a
reduceEntriesIO _ Null    = return mempty
reduceEntriesIO _ (One x) = return x
reduceEntriesIO f x       = f (getChoices x) >>= return . (reduce x) >>= reduceEntriesIO f

makeAlternatives :: [ a ] -> Alternative a
makeAlternatives [] = Null
makeAlternatives [x] = One x
makeAlternatives (x:y:xs) = Two x y (makeAlternatives xs)
