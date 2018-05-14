module Core.Data where

-- Two state data type
type Choice = Bool
type Entry = String

class Bracket a where
    leftReduce  :: a -> a
    rightReduce :: a -> a
    join :: a -> a -> [a]
