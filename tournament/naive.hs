module Tournament.Naive(chooseEntry) where

import Core.Data
import Core.Parser

import qualified Control.Applicative as Ap

data Alternative = Two (Entry, Entry) | One Entry

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


