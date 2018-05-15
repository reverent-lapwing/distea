import Data.Maybe
import Control.Monad (join)
import Control.Arrow
import System.IO

-- ================= --

import Tournament.Naive
import Core.Data

-- ================= --

readEntries :: IO String
readEntries = getLine

parseEntries :: String -> [ Entry ]
parseEntries [] = []
parseEntries x = (\(a,b) -> [ a ] ++ (parseEntries (drop 1 b))) (break (== ',') x)

makeAlternatives :: [ Entry ] -> [ Alternative ]
makeAlternatives [] = []
makeAlternatives [x] = [ One x ]
makeAlternatives (x:y:xs) = [Two (x, y) ] ++ ( makeAlternatives xs )

showChoices :: Alternative -> Maybe ( IO () )
showChoices (Two (x,y)) = Just ( putStrLn ( x ++ " or " ++ y ++ "?" ) >> hFlush stdout )
showChoices _ = Nothing

parseChoice :: String -> Maybe Choice
parseChoice "l" = Just True
parseChoice "r" = Just False
parseChoice _ = Nothing

readChoice :: IO Choice
readChoice =
        getLine >>=
        (return . parseChoice) >>=
        (\x -> case x of
            Just x -> return x
            Nothing -> putStrLn "Wrong input" >> hFlush stdout >> readChoice
        )
        
getChoice :: Bracket b => Choice -> (b -> b)
getChoice True = leftReduce
getChoice False = rightReduce

-- ================= --

getAlternatives :: String -> [ Alternative ]
getAlternatives = makeAlternatives . parseEntries

readChoices :: [ Alternative ] -> IO [ (Alternative -> Alternative) ]
readChoices = sequence . (fmap (>> (readChoice >>= (return . getChoice)))) . catMaybes . (fmap showChoices)

reduceEntries :: [ Alternative ] -> IO Alternative
reduceEntries [] = return (One "")
reduceEntries [One x] = return (One x)
reduceEntries xs = reduceEntries =<< ((\(x, y) -> x >>= (return . (flip combine) y)) <<< ((readChoices) &&& id)) xs

-- ================= --

main :: IO ()
main = readEntries >>= ( reduceEntries . getAlternatives ) >>=  \x -> case x of
    One x -> putStrLn x
    Two (x,y) -> putStrLn x >> putStrLn y