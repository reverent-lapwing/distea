import Data.Maybe
import qualified Control.Applicative as Ap
import Control.Monad (join)
import Control.Arrow
import System.IO

-- ================= --

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
showChoices (Two (x,y)) = Just ( putStrLn ( x ++ " or " ++ y ++ "?" ) >> hFlush stdout )
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
            Nothing -> putStrLn "Wrong input" >> hFlush stdout >> readChoice
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

-- ================= --

getAlternatives :: String -> [ Alternative ]
getAlternatives = makeAlternatives . parseOptions

readChoices :: [ Alternative ] -> IO [ (Alternative -> Option) ]
readChoices = sequence . (fmap (>> (readChoice >>= (return . getChoice)))) . catMaybes . (fmap showChoices)

reduceOptions :: [Option] -> IO Option
reduceOptions [] = return ""
reduceOptions [x] = return x
reduceOptions xs = reduceOptions =<< ((\(x, y) -> x >>= (return . (flip combine) y)) <<< ((readChoices) &&& id) <<< makeAlternatives) xs

-- ================= --

main :: IO ()
main = readOptions >>= ( reduceOptions . parseOptions ) >>= putStrLn