module Tournament.Naive(chooseEntry) where

import Core.Data
import Core.Bracket
import Core.Parser

import Data.Monoid

import qualified Control.Applicative as Ap

data Alternative = Two Entry Entry Alternative | One Entry Alternative | Null

instance Bracket Alternative where
    reduce (Two x y _) (All True)  = One x Null
    reduce (Two x y _) (All False) = One y Null
    reduce (One x _)    _          = One x Null
    reduce _            _          = Null
    
    getChoices (Two x y _) = [x,y]
    getChoices (One x _)   = [x]


chooseEntry :: ([ Entry ] -> IO Choice) -> [ Entry ] -> IO Entry
chooseEntry f x = (reduceEntries f) $ makeAlternatives x

join :: Alternative -> Alternative -> [ Alternative ]
join (One x _) (One y _) = [ Two x y Null ]
join  x        y         = [ x, y ]

collapse :: [ Alternative ] -> [ Alternative ]
collapse [] = []
collapse [x] = [x]
collapse (x:y:xs) = (join x y) ++ collapse xs


reduceEntries :: ([ Entry ] -> IO Choice) -> [ Alternative ] -> IO Entry
reduceEntries _ [] = return ""
reduceEntries _ [One x _] = return x
reduceEntries f xs = (reduceEntries f) =<< return . collapse =<< (sequence . (fmap ((\x -> f (getChoices x) >>= (return . (reduce x)) )))) xs

makeAlternatives :: [ Entry ] -> [ Alternative ]
makeAlternatives [] = []
makeAlternatives [x] = [ One x Null ]
makeAlternatives (x:y:xs) = [Two x y Null] ++ makeAlternatives xs


