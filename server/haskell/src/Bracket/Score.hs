module Bracket.Score() where

{- NOT IMPLEMENTED

import Core.Data
import Bracket.Bracket
import Core.Parser

import Data.Monoid hiding (Alt)
import Data.List

type Score = Int

data Alt a b = Alt (a, b)

instance Eq a => Eq (Alt a b) where
    (==) (Alt (x, _)) (Alt (y, _)) = (==) x y

instance Ord a => Ord (Alt a b) where
    compare (Alt (x, _)) (Alt (y, _)) = compare x y
    
    (<=) x y = (/=) GT $ compare x y

instance Functor (Alt a) where
    fmap f (Alt (s, x)) = Alt (s, f x)
    
    
instance Monoid a => Applicative (Alt a) where
    pure x = Alt (mempty, x)
    (<*>) (Alt (_, f)) x = fmap f x


instance (Ord a, Monoid a, Monoid b) => Semigroup (Alt a b) where
    (<>) x y = 
        case c of 
            GT -> x
            LT -> y
            EQ -> mappend <$> x <*> y
        where c = compare x y


instance (Ord a, Monoid a, Monoid b) => Monoid (Alt a b) where
    mempty = Alt (mempty, mempty)
    mconcat [] = mempty
    mconcat x = head (sort x)

score :: Monoid a => a -> Alt a b -> Alt a b
score s' (Alt (s, x)) = Alt (s `mappend` s', x)

instance Monoid a => Monad (Alt a) where
    (>>=) (Alt (s, x)) f = score s (f x)

reject :: Alt Choice b -> Alt Choice b
reject = score (All False)
    
applyChoice :: (Choice, Entry) -> Alt Choice [ Entry ]
applyChoice (c, e) = Alt (c, [e])

processChoices :: [ (Choice, Entry) ] -> Alt Choice [ Entry ]
processChoices xs = mconcat $ ( fmap applyChoice xs )

reduce :: Functor t => Choice -> t a -> Alt Choice (t a)
reduce c x = Alt (c, x)

liftAlt :: [a] -> Alt Choice [a]
liftAlt = pure

{-

readChoice >>= ( alts >>= reduce )

-}

{-    
instance Bracket Alt a b where
    reduce :: 
    

instance Bracket Alternative where
    reduce readChoice alt =
        case x of 
            Just x -> (<*>) ((readChoice x) >>= (return . getChoice)) $ return alt
            Nothing -> return alt
        where x = showChoices alt

chooseEntry :: (String -> IO Choice) -> [ Entry ] -> IO Entry
chooseEntry f x = (reduceEntries f) $ makeAlternatives x


getChoice :: Choice -> Alternative -> Alternative
getChoice True = leftReduce
getChoice False = rightReduce

leftReduce :: Alternative -> Alternative
leftReduce (One x) = One x
leftReduce (Two (x, _)) = One x

rightReduce :: Alternative -> Alternative
rightReduce (One x) = One x
rightReduce (Two (_, y)) = One y


showChoices :: Alternative -> Maybe ( String )
showChoices (Two (x,y)) = Just ( x ++ " or " ++ y ++ "?" )
showChoices _ = Nothing


join :: Alternative -> Alternative -> [ Alternative ]
join (One x) (One y) = [Two (x,y)]
join x y = [x, y]

collapse :: [ Alternative ] -> [ Alternative ]
collapse [] = []
collapse [x] = [x]
collapse (x:y:xs) = (join x y) ++ collapse xs

reduceEntries :: (String -> IO Choice) -> [ Alternative ] -> IO Entry
reduceEntries _ [] = return ""
reduceEntries _ [One x] = return x
reduceEntries f xs = (reduceEntries f) =<< return . collapse =<< (sequence . (fmap (reduce f))) xs


makeAlternatives :: [ Entry ] -> [ Alternative ]
makeAlternatives [] = []
makeAlternatives [x] = [ One x ]
makeAlternatives (x:y:xs) = [Two (x, y) ] ++ ( makeAlternatives xs )
-}
-}

