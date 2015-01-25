{-| FreeBSD tools to manage ports
 -}
module Config.FreeBSD.PortTools (isPortmasterPresent, isPkgToolsPresent, isPkgNgPresent, isPkgPresent) where

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

{-| Run pkg help and check exit status
 -}
checkPkg :: IO Bool
checkPkg = checkExitCode "pkg" ["help"]

{-| Run pkg_version -h (pre-NG package solution) and check exit status
 -}
checkOldPkg :: IO Bool
checkOldPkg = checkExitCode "pkg_version" ["-h"]

{-| Return false for any exceptions
 -}
handler :: SomeException -> IO Bool
handler _ = return False

{-| Check whether portmaster is installed by simply looking if we can run the command
 -}
isPortmasterPresent :: IO Bool
isPortmasterPresent = catch checkPortmaster handler

{-| Check whether pkgtools is installed by simply looking if we can run portupgrade command
 -}
isPkgToolsPresent :: IO Bool
isPkgToolsPresent = catch checkPortupgrade handler

{-| Check whether pkgNG is installed by simply looking if we can run pkg command
 -}
isPkgNgPresent :: IO Bool
isPkgNgPresent = catch checkPkg handler

{-| Check for pre-NG package manager
 -}
isPkgPresent :: IO Bool
isPkgPresent = catch checkOldPkg handler

