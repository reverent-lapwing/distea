module Tournament.Naive where

import Core.Data
import qualified Control.Applicative as Ap

data Alternative = Two (Entry, Entry) | One Entry

instance Bracket Alternative where
    leftReduce (One x) = One x
    leftReduce (Two (x, _)) = One x
    
    rightReduce (One x) = One x
    rightReduce (Two (_, y)) = One y
    
    join (One x) (One y) = [Two (x,y)]
    join (Two (x,y)) z = [Two (x,y), z]
    join z (Two (x,y)) = [z, Two (x,y)]
    
collapse :: [ Alternative ] -> [ Alternative ]
collapse [] = []
collapse [x] = [x]
collapse (x:y:xs) = (join x y) ++ collapse xs
    
combine :: [ (Alternative -> Alternative) ] -> [ Alternative ] -> [ Alternative ]
combine f x = collapse $ Ap.getZipList ( (Ap.ZipList (f ++ (cycle [leftReduce]))) <*> (Ap.ZipList x)) 