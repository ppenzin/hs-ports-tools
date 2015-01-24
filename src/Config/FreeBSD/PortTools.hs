{-| FreeBSD tools to manage ports
 -}
module Config.FreeBSD.PortTools (isPortmasterPresent, isPortupgradePresent) where

import System.Process
import System.Exit
import Control.Exception

{-| Run portmaster --help and check exit status
 -}
checkPortmaster :: IO Bool
checkPortmaster = readProcessWithExitCode "portmaster" ["--help"] "" >>= \(status, _, _) -> return (status == ExitSuccess)

{-| Run portupgrade --help and check exit status
 -}
checkPortupgrade :: IO Bool
checkPortupgrade = readProcessWithExitCode "portupgrade" ["--help"] "" >>= \(status, _, _) -> return (status == ExitSuccess)

{-| Return false for any exceptions
 -}
handler :: SomeException -> IO Bool
handler _ = return False

{-| Check whether portmaster is installed by simply looking if we can run the command
 -}
isPortmasterPresent :: IO Bool
isPortmasterPresent = catch checkPortmaster handler

{-| Check whether portupgrade is installed by simply looking if we can run the command
 -}
isPortupgradePresent :: IO Bool
isPortupgradePresent = catch checkPortupgrade handler


