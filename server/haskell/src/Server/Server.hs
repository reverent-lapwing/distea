{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
module Server.Server(mainServer) where

    import Control.Applicative ((<$>), (<*>))
    import Data.Maybe
    import Data.Text
    import Data.Monoid
    import System.IO
    
    -- ================= --
    
    import Bracket.Elimination as Elimination
    import Core.Parser
    import Core.Data
    
    -- ================= --
    
    import Yesod

    data App = App

    mkYesod "App" [parseRoutes|
    / HomeR GET
    /console ConsoleR POST
    |]

    instance Yesod App

    instance RenderMessage App FormMessage where
        renderMessage _ _ = defaultFormMessage

    data Input = Input
            { inputText :: Text }
        deriving Show

    consoleForm :: Html -> MForm Handler (FormResult Input, Widget)
    consoleForm = renderDivs $ Input <$> areq textField "Text" Nothing

    getHomeR = do
        (widget, enctype) <- generateFormPost consoleForm
        defaultLayout $ do
            setTitle "Distiea"
            [whamlet|
                <h1>SAMPLE HEADING
                <a>SOME TEXT HERE
                <form method=post action=@{ConsoleR} enctype=#{enctype}>
                    ^{widget}
                    <button>Submit
            |]

    postConsoleR = do
        ((result, widget), enctype) <- runFormPost consoleForm
        case result of
            FormSuccess input -> defaultLayout [whamlet|<p>#{show input}|]
            _ -> defaultLayout
                [whamlet|
                    <p>Invalid input, let's try again.
                    <form method=post action=@{ConsoleR} enctype=#{enctype}>
                        ^{widget}
                        <button>Submit
                |]


    readMethod :: IO ( [ Entry ] -> IO Entry )
    readMethod = putStrLn "Choose destilation method" >> hFlush stdout >> getLine >> return (Elimination.chooseEntryIO readChoice)
    
    readEntries :: IO [ Entry ]
    readEntries = putStrLn "Input options" >> hFlush stdout >> getLine >>= return . splitEntries
    
    readChoice :: [ Entry ] -> IO Choice
    readChoice xs =
            (\x -> case x of
                Just x -> x
                Nothing -> return True
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
    
    mainServer :: IO ()
    mainServer = warp 3000 App
        --readMethod >>= ( readEntries >>= ) >>= putStrLn
    
    