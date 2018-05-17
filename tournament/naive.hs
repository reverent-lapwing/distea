module Tournament.Naive(chooseEntry) where

import Core.Data
import Core.Bracket
import Core.Parser

import Data.Monoid

import qualified Control.Applicative as Ap

--data Alternative = Entry Entry :++> Alternative | Entry :+> Alternative | Null
data Alternative = Two Entry Entry | One Entry

instance Bracket Alternative where
    reduce (One x)    _          = One x
    reduce (Two x y) (All True)  = One x
    reduce (Two x y) (All False) = One y
    
    getChoices (Two x y) = [x,y]
    getChoices (One x)     = [x]


chooseEntry :: ([ Entry ] -> IO Choice) -> [ Entry ] -> IO Entry
chooseEntry f x = (reduceEntries f) $ makeAlternatives x


join :: Alternative -> Alternative -> [ Alternative ]
join (One x) (One y)= [Two x y]
join      x       y = [x, y]

collapse :: [ Alternative ] -> [ Alternative ]
collapse [] = []
collapse [x] = [x]
collapse (x:y:xs) = (join x y) ++ collapse xs


reduceEntries :: ([ Entry ] -> IO Choice) -> [ Alternative ] -> IO Entry
reduceEntries _ [] = return ""
reduceEntries _ [One x] = return x
reduceEntries f xs = (reduceEntries f) =<< return . collapse =<< (sequence . (fmap ((\x -> f (getChoices x) >>= (return . (reduce x)) )))) xs

makeAlternatives :: [ Entry ] -> [ Alternative ]
makeAlternatives [] = []
makeAlternatives [x] = [ One x ]
makeAlternatives (x:y:xs) = [Two x y ] ++ ( makeAlternatives xs )


