import Data.Maybe
import qualified Control.Applicative as Ap
import Control.Monad (join)

readOptions :: IO String
readOptions = getLine

type Option = String

parseOptions :: String -> [ Option ]
parseOptions [] = []
parseOptions x = (\(a,b) -> [ a ] ++ (parseOptions (drop 1 b))) (break (== ',') x)

data Alternative = Two (Option, Option) | One Option

makeAlternatives :: [ Option ] -> [ Alternative ]
makeAlternatives [] = []
makeAlternatives [x] = [ One x ]
makeAlternatives (x:y:xs) = [Two (x, y) ] ++ ( makeAlternatives xs )

showChoices :: Alternative -> Maybe ( IO () )
showChoices (Two (x,y)) = Just ( putStrLn ( x ++ " or " ++ y ++ "?" ) )
showChoices _ = Nothing

-- Two state data type
type Choice = Bool

parseChoice :: String -> Maybe Choice
parseChoice "Left" = Just True
parseChoice "Right" = Just False
parseChoice _ = Nothing

readChoice :: IO Choice
readChoice =
        getLine >>=
        (return . parseChoice) >>=
        (\x -> case x of
            Just x -> return x
            Nothing -> putStrLn "Wrong input" >> readChoice
        )

leftReduce :: Alternative -> Option
leftReduce (One x) = x
leftReduce (Two (x, _)) = x

rightReduce :: Alternative -> Option
rightReduce (One x) = x
rightReduce (Two (_, y)) = y

getChoice :: Choice -> (Alternative -> Option)
getChoice True = leftReduce
getChoice False = rightReduce

combine :: [ (Alternative -> Option) ] -> [ Alternative ] -> [ Option ]
combine f x = Ap.getZipList ( (Ap.ZipList (f ++ (cycle [leftReduce]))) <*> (Ap.ZipList x)) 

main :: IO ()
main = readOptions >>= ( (foldr (>>) (return ())) . (fmap (>> (readChoice >>= (return . getChoice)))) . catMaybes . (fmap showChoices) . {- split here  -} makeAlternatives . parseOptions )

