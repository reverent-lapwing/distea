module Core.Data where

-- Two state data type
type Choice = Bool
type Entry = String

class Bracket a where
    reduce :: (String -> IO Choice) -> a -> IO a
