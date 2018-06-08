module Main where 

import Server.Server
import Core.Cli

import System.Environment
import Control.Arrow

main :: IO ()
main = getArgs >>= (any (== "-cli") >>> (\b -> if b then mainCLI else mainServer))
