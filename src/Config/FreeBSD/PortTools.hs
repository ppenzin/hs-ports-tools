{-| FreeBSD tools to manage ports
 -}
module Config.FreeBSD.PortTools (isPortmasterPresent, isPortupgradePresent) where

import System.Process
import System.Exit
import Control.Exception

{-| Run something and check if the exit code is "success"
 -}
checkExitCode :: String -> [String] -> IO Bool
checkExitCode nm args = readProcessWithExitCode nm args "" >>= \(status, _, _) -> return (status == ExitSuccess)

{-| Run portmaster --help and check exit status
 -}
checkPortmaster :: IO Bool
checkPortmaster = checkExitCode "portmaster" ["--help"]

{-| Run portupgrade --help and check exit status
 -}
checkPortupgrade :: IO Bool
checkPortupgrade = checkExitCode "portupgrade" ["--help"]

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


