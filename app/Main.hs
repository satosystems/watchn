module Main where

import Data.List
import Data.List.Split
import System.Environment
import System.IO
import System.FSNotify
import System.Process
import Watcher

type FileFilter = String
type Command = String
type EventFilter = String

data Options = Options
  { command :: Maybe Command
  , fileName :: Maybe FileFilter
  , eventFilter :: Maybe EventFilter
  , help :: Bool
  , version :: Bool
  }

main :: IO ()
main = do
  args <- getArgs
  let options = parseOptions args
  case options of
    (Options _ _ _ True _) -> showUsage
    (Options _ _ _ _ True) -> showVersion
    (Options (Just c) mfn (Just e) _ _) -> watchAnd c mfn e
    (Options _ _ _ _ _) -> showUsage

watchAnd :: Command -> Maybe FileFilter -> EventFilter -> IO ()
watchAnd c mfn ef = watchWith $ \event -> do
  let matched = match mfn event
  if not matched then return () else case event of
    (Added filePath _) -> if "A" `isInfixOf` ef then run c filePath else return ()
    (Modified filePath _) -> if "M" `isInfixOf` ef then run c filePath else return ()
    (Removed filePath _) -> if "R" `isInfixOf` ef then run c filePath else return ()
 where
  match (Just fn) (Added filePath _) = fn `isSuffixOf` filePath
  match (Just fn) (Modified filePath _) = fn `isSuffixOf` filePath
  match (Just fn) (Removed filePath _) = fn `isSuffixOf` filePath
  match _ _ = True

run :: Command -> FilePath -> IO ()
run c filePath = system c' >> return ()
 where
  c' = concat $ init $ foldl (\x y -> x ++ [y] ++ [filePath]) [] (splitOn "?" c)

showVersion :: IO ()
showVersion = putStrLn "watchn 0.1.0.0"

showUsage :: IO ()
showUsage = hPutStrLn stderr $ unlines usage
 where
  usage = [ "Usage:"
          , "  watchn -c 'open ?' -f out.png -e M"
          , "  watchn -c \"cat ?\" -e AM"
          , "  watchn -c 'touch ?' -f .lock -e R"
          , ""
          , "Available options:"
          , "  -c 'command'       Command when matched file"
          , "                       ('?' means mached file name)"
          , "  -f 'filename'      Filter watching file name (optional)"
          , "  -e [A|M|R]         Filter events (optional)"
          , "                       A: Added"
          , "                       M: Modified"
          , "                       R: Removed"
          , "  -H|--help          Show this help"
          , "  -V|--version       Show version"
          ]

parseOptions :: [String] -> Options
parseOptions args = parse args $ Options Nothing Nothing Nothing False False
 where
  parse [] opt@(Options _ _ (Just _) _ _) = opt
  parse [] opt@(Options _ _ Nothing _ _) = opt { eventFilter = Just "AMR" }
  parse ("-f":fn:ss) opt = parse ss $ opt { fileName = Just fn }
  parse ("-c":c:ss) opt = parse ss $ opt { command = Just c }
  parse ("-e":ef:ss) opt = parse ss $ opt { eventFilter = Just ef }
  parse ("--help":ss) opt = parse ss $ opt { help = True }
  parse ("-H":ss) opt = parse ss $ opt { help = True }
  parse ("--version":ss) opt = parse ss $ opt { version = True }
  parse ("-V":ss) opt = parse ss $ opt { version = True }
  parse (_:ss) opt = parse ss opt

