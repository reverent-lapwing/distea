module Core.Cli(mainCLI) where

import Data.Maybe
import Data.Monoid
import System.IO

-- ================= --

import Tournament.Naive as Naive
import Tournament.Score as Score
import Core.Parser
import Core.Data

-- ================= --

readMethod :: IO ( [ Entry ] -> IO Entry )
readMethod = putStrLn "Choose destilation method" >> hFlush stdout >> getLine >> return (Naive.chooseEntryIO readChoice)

readEntries :: IO [ Entry ]
readEntries = putStrLn "Input options" >> hFlush stdout >> getLine >>= return . splitEntries

readChoice :: [ Entry ] -> IO Choice
readChoice xs =
        (\x -> case x of
            Just x -> x
            Nothing -> return (All True)
        )
        $ showChoices xs >>= (\s -> Just $
            putStrLn s >> hFlush stdout >>
            getLine >>=
            (return . parseChoice) >>=
            (\x -> case x of
                Just x -> return x
                Nothing -> putStrLn "Wrong input" >> hFlush stdout >> readChoice xs
            ))
        
-- ================= --

mainCLI :: IO ()
mainCLI = 
    readMethod >>= ( readEntries >>= ) >>= putStrLn

