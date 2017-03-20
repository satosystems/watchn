module Watcher (watchWith) where

import System.Exit
import System.FSNotify
import System.IO.Error
import System.Posix.Directory

watchWith :: (Event -> IO ()) -> IO ()
watchWith callback = do
  dir <- getWorkingDirectory
  withManager $ \manager -> do
    _ <- watchDir manager dir (const True) $ \event -> callback event
    waitBreak
 where
  waitBreak = do
    _ <- catchIOError getLine (\e -> if isEOFError e then exitSuccess else exitFailure)
    waitBreak

