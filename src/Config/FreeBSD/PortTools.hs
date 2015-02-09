{- |
Module      :  $Header$
License     :  FreeBSD

Maintainer  :  penzin.dev@gmail.com
Stability   :  experimental
Portability :  non-portable (FreeBSD specific)

Module to check existence and interact with various port and package tools

-}
module Config.FreeBSD.PortTools (
        -- * Functions
        -- ** Check for Portmater
        isPortmasterPresent,
        -- ** Check for PkgTools (portupgrade and the like)
        isPkgToolsPresent,
        -- ** Check for PkgNG (newer package tool)
        isPkgNgPresent,
        -- ** Check for Pkg (older package tool)
        isPkgPresent,
        -- ** Upgrade a port using portmaster
        upgradeWithPortmaster,
        -- ** Upgrade a port using portupgrade
        upgradeWithPortupgrade,
        -- ** Upgrade a port using make command
        upgradeWithMake
    ) where

import System.Process
import System.Exit
import System.Directory
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

{-| Check whether portmaster is installed by looking if we can run the command
 -}
isPortmasterPresent :: IO Bool
isPortmasterPresent = catch checkPortmaster handler

{-| Check whether pkgtools is installed by looking if we can run portupgrade command
 -}
isPkgToolsPresent :: IO Bool
isPkgToolsPresent = catch checkPortupgrade handler

{-| Check whether pkgNG is installed by looking if we can run pkg command
 -}
isPkgNgPresent :: IO Bool
isPkgNgPresent = catch checkPkg handler

{-| Check for pre-NG package manager
 -}
isPkgPresent :: IO Bool
isPkgPresent = catch checkOldPkg handler

{-| Upgrade a single port with portmaster -}
upgradeWithPortmaster :: String -> IO ()
upgradeWithPortmaster name = callProcess "portmaster" [name]

{-| Upgrade a single port with portupgrade -}
upgradeWithPortupgrade :: String -> IO ()
upgradeWithPortupgrade name = callProcess "portupgrade" [name]

{-| Upgrade a single port using Make -}
upgradeWithMake :: String -> IO ()
upgradeWithMake name = readProcess "find" ["/usr/ports", name] "" -- cheat to locate the port directory
                   >>= setCurrentDirectory
                    >> callProcess "make" ["config-recursive"]
                    >> callProcess "make" ["install", "clean"]

