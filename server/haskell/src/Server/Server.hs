{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE ViewPatterns               #-}
{-# LANGUAGE ScopedTypeVariables        #-}

module Server.Server (mainServer) where 

import Database.Persist
import Database.Persist.Sqlite
import Database.Persist.TH

import Control.Monad.Trans.Resource (runResourceT)
import Control.Monad.Logger (runStderrLoggingT)

import Yesod
import Yesod.Static

import Data.Aeson
import Data.Aeson.Types

import System.Environment

import Control.Applicative

import Data.Maybe

import qualified Data.Text as T
import qualified Data.ByteString as BS

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Names
    name T.Text
    deriving Show
|]

data App = App
    { getStatic :: Static
    , appRoot   :: String
    , connection :: ConnectionPool
    }

newtype Create = Create
    { names :: T.Text }

instance FromJSON Create where
    parseJSON (Object v) = Create <$>
                           v .: "names"
    parseJSON _ = empty

mkYesod "App" [parseRoutes|
/ HomeR GET
/static StaticR Static getStatic
/create CreateR POST
/list/#NamesId ListR GET
|]

instance Yesod App

instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend

    runDB action = do
        (App _ _ connection) <- getYesod
        runSqlPool action connection

getHomeR :: Handler Html
getHomeR = do
    app <- getYesod
    sendFile "text/html" (appRoot app ++ "/index.html")

postCreateR :: Handler TypedContent
postCreateR = do
    testData :: Create <- requireJsonBody
    id <- runDB $ do
        runMigration migrateAll
        insert $ Names $ names testData 
    selectRep $ provideRep $ return $ object [ "id" .= id ]
    
  
getListR :: NamesId -> Handler TypedContent
getListR nameId = do
    names <- runDB $ get nameId
    --selectRep $ provideRep $ return $ object [ "names" .= name ]
    case names of
        Just x  -> selectRep $ provideRep $ return $ object [ "names" .= namesName x ]
        Nothing -> selectRep $ provideRep $ return emptyObject

openConnectionCount :: Int
openConnectionCount = 10

mainServer :: IO ()
mainServer = runStderrLoggingT $ withSqlitePool "test.db3" openConnectionCount $ \pool -> liftIO $ do
    runResourceT $ flip runSqlPool pool $
        runMigration migrateAll
    appRoot <- getEnv "APPROOT" 
    static@(Static settings) <- static (appRoot ++ "/static")
    warp 3000 $ App static appRoot pool