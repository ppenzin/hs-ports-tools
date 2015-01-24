{-| FreeBSD tools to manage ports
 -}
module Config.FreeBSD.PortTools where

import System.Process
import System.Exit

{-| Check whether portmaster is installed by simply looking if we can run the command
 -}
isPortmasterPresent :: IO Bool
isPortmasterPresent = readProcessWithExitCode "portmaster" ["--help"] "" >>= \(status, _, _) -> return (status == ExitSuccess)

{-| Check whether portupgrade is installed by simply looking if we can run the command
 -}
isPortupgradePresent :: IO Bool
isPortupgradePresent = readProcessWithExitCode "portupgrade" ["--help"] "" >>= \(status, _, _) -> return (status == ExitSuccess)


