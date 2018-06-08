{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}

module Server.Server (mainServer) where 

import Yesod
import Yesod.Static
import System.Environment
import Data.Text

data App = App
    { getStatic :: Static
    , appRoot   :: String
    }

mkYesod "App" [parseRoutes|
/ HomeR GET
/static StaticR Static getStatic
|]

instance Yesod App

getHomeR :: Handler Html
getHomeR = do
    app <- getYesod
    sendFile "text/html" (appRoot app ++ "/index.html")


mainServer :: IO ()
mainServer = do
    appRoot <- getEnv "APPROOT" 
    static@(Static settings) <- static (appRoot ++ "/static")
    warp 3000 $ App static appRoot