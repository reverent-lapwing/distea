module Tournament.Naive(chooseEntry) where

import Core.Data
import Core.Bracket
import Core.Parser

import Data.Monoid

import qualified Control.Applicative as Ap

data Alternative a = Two a a (Alternative a) | One a (Alternative a) | Null

instance Bracket Alternative where
    reduce (Two x y xs) (All True)  = xs `join` (One x Null)
    reduce (Two x y xs) (All False) = xs `join` (One y Null)
    reduce (One x xs)    _          = xs `join` (One x Null)
    reduce _             _          = Null
    
    getChoices (Two x y _) = [x,y]
    getChoices (One x _)   = [x]
    getChoices _           = []

instance Functor Alternative where
    fmap _  Null        = Null
    fmap f (One x xs)   = (One (f x) (fmap f xs))
    fmap f (Two x y xs) = (Two (f x) (f y) (fmap f xs))
  
chooseEntry :: Monoid a => ([ a ] -> IO Choice) -> [ a ] -> IO a
chooseEntry f x = (reduceEntries f) $ makeAlternatives x

join :: Alternative a -> Alternative a -> Alternative a
join  Null        x  = x
join (One x Null) x' = collapse (One x x')
join (One x xs)   x' = join (collapse (One x xs)) x'
join (Two x y xs) x' = Two x y (join xs x')


collapse :: Alternative a -> Alternative a
collapse  Null                  = Null
collapse (One x    Null       ) = One x Null
collapse (One x   (One y xs)  ) = Two x y (collapse xs)
collapse (One x   (Two y z xs)) = Two x y (collapse (One z xs))
collapse (Two x y  xs         ) = Two x y (collapse xs)


altMap :: (Alternative a -> Alternative b) -> Alternative a -> Alternative b
altMap _  Null        = Null
altMap f (One x   xs) = join (f (One x   Null)) (altMap f xs)
altMap f (Two x y xs) = join (f (Two x y Null)) (altMap f xs)


reduceEntries :: Monoid a => ([ a ] -> IO Choice) -> Alternative a -> IO a
reduceEntries _ Null = return mempty
reduceEntries _ (One x Null) = return x
reduceEntries f x = f (getChoices x) >>= return . (reduce x) >>= reduceEntries f

makeAlternatives :: [ a ] -> Alternative a
makeAlternatives [] = Null
makeAlternatives [x] = One x Null
makeAlternatives (x:y:xs) = Two x y (makeAlternatives xs)


